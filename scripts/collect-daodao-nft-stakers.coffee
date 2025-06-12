import { fromBase64, toUtf8 } from '@apophis-sdk/core/utils.js'
import { CosmWasm } from '@apophis-sdk/cosmwasm'
import fs from 'fs/promises'
import { networks } from '~/config.js'

network = await networks.terra2
treasury = "terra1c690mdrwdetnr09zfk3tf9xz9jhrgd9wpjyf3tuccj74ql09eqmq6sh7en"

if process.argv.length < 3
  console.log "Usage: collect-daodao-nft-stakers.coffee <output-file>"
  process.exit 0

outputFile = process.argv[2]

votingModule = await CosmWasm.query.smart network, treasury, { voting_module: {} }

isNbKey = (key) -> CosmWasm.decodeKeypath(key)[0] is 'nb'

stakers = []

nextKey = CosmWasm.encodeKeypath ['nb', '0']
while isNbKey nextKey
  { pagination, items } = await CosmWasm.query.state network, votingModule, nextKey
  stakers.push items.filter(({ keypath }) -> keypath[0] is 'nb')...
  nextKey = fromBase64 pagination.next_key

stakers = stakers
  .map ({ keypath, value }) ->
    # slice away the quotes, ain't nobody gonna have >2^53 NFTs staked
    # note: this assumes the NFT IDs are numbers, which they don't have to be for CW721
    # but the ERC721 standard uses numbers, so you'd be a masochist to use non-numeric IDs
    [keypath[1], JSON.parse(toUtf8(value).slice(1, -1))]
  .filter ([_, count]) -> count > 0
stakers = Object.fromEntries stakers

await fs.writeFile outputFile, JSON.stringify(stakers, null, 2)
