#!/bin/bash
curl -sSL "https://goblin.reaper.im/github.com/barelyhuman/statico" | sh; statico;

# Make sure you have node and npx installed
npx purgecss --config purgecss.config.js