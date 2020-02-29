# Description
#   A hubot script that does the things
#
# Configuration:
#   HUBOT_RUN="bash/handler"
#   PYTHON_EXECUTABLE="/usr/bin/python"
#   PYTHON_SCRIPT_FOLDER=""
# Commands:
#  run - Lists the available commands.
#  run <command_name> - Runs the command <command_name>.
#  list
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Dhaval

##########################################################
# Check if handler exists and set default handler
##########################################################
fs = require("fs")

process.env.HUBOT_RUN = "bash/handler" if not process.env.HUBOT_RUN
if not fs.existsSync(process.env.HUBOT_RUN)
  console.log process.env.HUBOT_RUN+" not found in hubot working dir... Defaulting to example handler at "+__dirname+"/../bash/handler"
  process.env.HUBOT_RUN = __dirname+"/../bash/handler"
process.env.PYTHON_SCRIPT_FOLDER = __dirname+"/../src/python/" if not process.env.PYTHON_SCRIPT_FOLDER
process.env.PYTHON_EXECUTABLE = "/usr/bin/python" if not process.env.PYTHON_EXECUTABLE
process.env.BASH_EXECUTABLE = "/usr/bash" if not process.env.BASH_EXECUTABLE

##########################################################

##########################################################
# module exports
##########################################################
module.exports = (robot) ->
  fs = require 'fs'
  fs.exists __dirname+'/logs/', (exists) ->
    if exists
      console.log "Log folder exists..."
    else
      fs.mkdir __dirname+'/logs/', (error) ->
        unless error
          console.log "Log folder created..."
        else
          console.log "Could not create logs directory: #{error}"
##########################################################

  ##########################################################
  # Run command:
  ##########################################################
  run_cmd = (cmd, args, envs, cb ) ->
    console.log "Running command: "+cmd+" "+args
    spawn = require("child_process").spawn
    opts =
        env: envs
    child = spawn(cmd, args, opts)

    child.stdout.on "data", (buffer) -> cb buffer.toString()
    child.stderr.on "data", (buffer) -> cb buffer.toString()
  ##########################################################


  ##########################################################
  # Run command:
  ##########################################################
  robot.respond "/.*/i", (res) ->

    cmd = process.env.PYTHON_EXECUTABLE

    # Copy environment variables to child process
    envs = {}
    envs[key.toUpperCase()] = value for key, value of process.env
    envs["HUBOT_USER_" + key.toUpperCase()] = value for key, value of res.envelope.user

    # input = res.match[0]
    input_array = res.match[0].split /\s+/
    # bot_name = input_array[0].toLowerCase()
    console.log input_array
    args = input_array[1..]
    input = input_array[1..].toString()
    console.log args

    # command = args[0].toLowerCase()
    executable_file = args[0].toLowerCase()
    command = process.env.PYTHON_SCRIPT_FOLDER + executable_file + ".py"
    # command = process.env.PYTHON_SCRIPT_FOLDER + "main.py"
    # Insert at index 0 without deleting any item.
    # args.splice(0, 0, command);
    args[0] = command
    console.log args

    room = res.message.room

    console.log "Input: " + input.replace(/\,/g, " ")
    # res.send "*Input:* `" + input.replace(/\,/g, " ") + "`. Processing. Will post `" + room + "` once i get the results..."
    res.send "*Input:* `" + input.replace(/\,/g, " ") + "`. Processing..."
    console.log args[0]
    console.log args
    # res.send args[0]
    # console.log args[0]

    fs = require 'fs'
    fs.exists args[0], (exists) ->
      if exists
        console.log "Command exists: " + args[0]
        run_cmd cmd, args, envs, (text) ->
          console.log text
          res.reply text
      else
        console.log "The command specified is not available: " + executable_file + "."
        res.reply "The command specified is not available: `" + executable_file + "`."
        args[0] = process.env.PYTHON_SCRIPT_FOLDER + "help.py"
        run_cmd cmd, args, envs, (text) ->
          console.log text
          res.reply text


  ##########################################################
