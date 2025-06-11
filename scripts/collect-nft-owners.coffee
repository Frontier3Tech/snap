import { CosmWasm } from '@apophis-sdk/cosmwasm'
import fs from 'fs/promises'
import path from 'path'
import { networks } from '~/config.js'

if process.argv.length < 3
  console.error "Usage: bun collect-nft-owners.coffee <path-to-store-json>"
  process.exit 1

filepath = process.argv[2]
await fs.mkdir path.dirname(filepath), recursive: true
save = -> await fs.writeFile filepath, JSON.stringify(store)

store = await fs.readFile(filepath, 'utf8')
  .then (data) -> JSON.parse data
  .catch -> {}

store ?= {}
store.tokenIds ?= []
store.owners ?= {}
store.ownersByToken ?= {}

network = await networks.terra2

contract = "terra17z7fpaa8kah698xn5tarrcucvualdy4wsztkfc404g3garucpu6qmxp50g"

if store.tokenIds.length is 0
  console.log "Collecting token IDs..."
  lastTokenId = undefined
  first = true
  while first or lastTokenId isnt undefined
    first = false
    response = await CosmWasm.query.smart network, contract,
      all_tokens:
        start_after: lastTokenId
        limit: 100
    lastTokenId = response.tokens[response.tokens.length - 1]
    store.tokenIds.push response.tokens...
  store.tokenIds = store.tokenIds.map String
  await save()
else
  console.log "Restored token IDs from #{filepath}"

console.log "Collecting owners..."
for tokenId in store.tokenIds
  if store.ownersByToken[tokenId]
    console.log "Skipping #{tokenId} because it already has an owner"
    continue
  console.log "Collecting owner for #{tokenId}..."
  { owner } = await CosmWasm.query.smart network, contract,
    owner_of:
      token_id: tokenId
  store.owners[owner] ?= []
  store.owners[owner].push tokenId
  store.ownersByToken[tokenId] = owner
  await save()
console.log "Done"
