# use after collect-daodao-nft-stakers.coffee & collect-nft-holders.coffee
import fs from 'fs/promises'
import yargs from 'yargs'

args = yargs(process.argv.slice(2))
  .option 'stakers',
    describe: 'Path to DAODAO stakers file, generated from collect-daodao-nft-stakers.coffee'
  .option 'holders',
    describe: 'Path to NFT holders file, generated from collect-nft-holders.coffee'
  .option 'ignore',
    describe: 'Path to ignore file. Should be a JSON array of addresses to ignore.'
  .option 'output',
    alias: 'o',
    describe: 'Path to output file'
  .demandOption ['stakers', 'holders', 'output']
  .parse()

stakers = JSON.parse await fs.readFile(args.stakers, 'utf8')
holders = JSON.parse await fs.readFile(args.holders, 'utf8')
holders = holders.owners
holders = Object.fromEntries Object.entries(holders).map ([key, tokenIds]) -> [key, tokenIds.length]

whitelist = new Set()

ignore = if args.ignore then new Set(JSON.parse await fs.readFile(args.ignore, 'utf8')) else new Set()

for [address, count] in Object.entries(stakers)
  continue if ignore.has(address) or count is 0
  whitelist.add address

whitelist = Array.from(whitelist).sort()

await fs.writeFile(args.output, 'Address\n' + whitelist.join('\n'))
