{-# language NumDecimals #-}

module Main where

import Fake
import Pipes
import Events
import Data.Yaml
import System.IO
import Control.Monad
import System.Process
import Data.Time.Clock
import Fake.Combinators
import Data.Time.Calendar
import Control.Concurrent
import Data.Time.Clock.POSIX
import Data.ByteString.Char8
import Fake.Provider.DateTime
import System.Process.Streaming

main :: IO ()
main = executeInteractive (shell "cat") { std_in = CreatePipe } (feedProducer periodic)

periodic :: Producer ByteString IO ()
periodic = do
  event <- lift createEvent
  Pipes.yield $ encode event 
  liftIO (threadDelay 1e6)
  periodic

twentyFourHours :: NominalDiffTime 
twentyFourHours = 60 * 60 * 24

getDataRange :: IO (UTCTime, UTCTime) 
getDataRange = do 
  now <- getCurrentTime
  let today = UTCTime (utctDay now) 0
  let tomorrow = addUTCTime twentyFourHours today
  return (today, tomorrow)

createEvent :: IO Event
createEvent = do 
  range <- getDataRange  
  time <- generate $ uncurry utcBetween range
  eventType <- generate $ elements eventTypes
  _data <- generate $ elements eventData 
  return $ Event { _data = _data, 
                   eventType = eventType, 
                   timestamp = (floor . utcTimeToPOSIXSeconds) time }

eventTypes :: [String]
eventTypes = ["mousemove", "mousedown", "mouseup", "mouseover", "click", "doubleclick"]

eventData :: [String]
eventData = ["clientX = 704, clientY = 358", 
             "clientX = 688, clientY = 422", 
             "clientX = 726, clientY = 200", 
             "clientX = 607, clientY = 35", 
             "clientX = 264, clientY = 484", 
             "clientX = 260, clientY = 354"]