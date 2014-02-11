'use strict'

express = require 'express'
jade    = require 'jade'

data     = require './lib/data'
validate = require './lib/validate'

app = require('clabot').createApp
  getContractors: data.getContractors
  token: process.env.GITHUB_TOKEN
  templateData:
    link: 'http://clabot.github.com/individual.html'
    maintainer: 'boennemann'
  secrets:
    excellenteasy:
      bradypodion: process.env.HUB_SECRET
      clatest: process.env.HUB_SECRET

app.use require('connect-assets')()
app.use(express.compress());

app.get '/form/:project/:kind?', (req, res) ->
  project = req.params.project
  # Makes no sense, yet. Extensible in the future.
  project ?= 'clabot'
  kind    = req.params.kind?.toLowerCase()
  kind    = kind.charAt(0).toUpperCase() + kind.slice 1 if kind
  if kind isnt 'Entity' then kind = 'Individual'

  res.render 'form.jade',
    agreement: "#{project} #{kind} Contributors License Agreement"
    kind     : kind
    layout   : no
    project  : project
    url      : req.clabotOptions.templateData.link

app.post '/form', validate, data.save

port = process.env.PORT or 1337

app.listen port
console.log "Listening on #{port}"

# debugging
process.on 'uncaughtException', (err) ->
  console.log 'Caught exception: ' + err
