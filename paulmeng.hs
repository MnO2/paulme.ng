{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Text.Pandoc
import           Text.Pandoc.Options
import qualified Data.Map as M
import qualified Data.Map.Lazy as ML
import           GHC.Generics

import           Control.Monad (zipWithM_)
import           Data.List (sortBy, intercalate)
import           Data.Time.Clock (UTCTime)
import           Data.Time.Format (parseTimeM)
import           Data.Maybe (fromJust)
import           System.FilePath (takeFileName)
import           Data.Time.Format (defaultTimeLocale)
import qualified Data.Yaml as Y

import           Text.Blaze.Html.Renderer.String (renderHtml)
import           Text.Blaze.Internal (preEscapedString)
import           Text.Blaze.Html ((!), toHtml, toValue)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

hakyllConfig = defaultConfiguration

data HaspotSetting = HaspotSetting {
  author :: HaspotAuthorSetting
} deriving Generic

data HaspotAuthorSetting = HaspotAuthorSetting {
  name :: String,
  email :: String,
  intro :: String
} deriving Generic

instance Y.FromJSON HaspotSetting
instance Y.FromJSON HaspotAuthorSetting


main :: IO ()
main = do 
  maybeConfig <- Y.decodeFile "conf/setting.yml"
  case maybeConfig of
      Just conf -> hakyllSetting conf
      Nothing -> putStrLn "Configuration Error"

pandocMathCompiler =
    let defaultExtensions = writerExtensions defaultHakyllWriterOptions
        newExtensions = enableExtension Ext_tex_math_dollars defaultExtensions 
        newExtensions' = enableExtension Ext_tex_math_double_backslash defaultExtensions 
        newExtensions'' = enableExtension Ext_latex_macros defaultExtensions 
        newExtensions''' = enableExtension Ext_simple_tables defaultExtensions
        writerOptions = defaultHakyllWriterOptions {
                          writerExtensions = newExtensions''',
                          writerHTMLMathMethod = MathJax ""
                        }
    in pandocCompilerWith defaultHakyllReaderOptions writerOptions

hakyllSetting :: HaspotSetting -> IO ()
hakyllSetting conf = do
    hakyllWith hakyllConfig $ do
      match "images/**" $ do
          route   idRoute
          compile copyFileCompiler
      
      match (fromList ["robots.txt", "favicon.ico"]) $ do
          route idRoute
          compile copyFileCompiler

      match "stylesheets/*" $ do
          route   idRoute
          compile compressCssCompiler
      
      match "javascript/*" $ do
          route   idRoute
          compile copyFileCompiler

      match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

authorCtx :: HaspotSetting -> Context a
authorCtx conf = field "author_name" ( \item -> do
                      metadata <- getMetadata $ itemIdentifier item
                      return $ name $ author conf
                      ) `mappend`
                 field "author_intro" ( \item -> do
                      metadata <- getMetadata $ itemIdentifier item
                      return $ intro $ author conf
                      )

pandocOptions :: WriterOptions
pandocOptions = defaultHakyllWriterOptions
