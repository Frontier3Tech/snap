# snap
Snapshot Toolkit for Cosmos Tokens & NFTs.

This project is currently still very rudimentary and just a simple script to collect a list of NFT holders & stakers on DAODAO. Eventually, I'd like to expand this project into a full Dapp that people can use to take snapshots of all sorts of things, from holders over DAODAO stakers and Superbolt listings to Astroport liquidity positions & more.

# Usage
Clone this repo. In its current form, the repo is built on [Bun](https://bun.sh). So install Bun if you haven't already, then run:

```bash
$ bun install
```

Alter the `scripts/collect-nft-owners.coffee` script to point to the NFT collection address of your choice and adjust the network. You can easily add a new network in the `src/config.ts` file. Then run:

```bash
$ bun ./scripts/collect-nft-owners.coffee path/to/store.json
```

It'll take some time as it collects large amounts of data from the blockchain. It uses some checkpoints to avoid loss in case of a crash, since public nodes can sometimes be unreliable.

The store file you've given will contain a lot of data in different relations. You should query it with the `jq` CLI tool like so:

```bash
$ cat path/to/store.json | jq '.owners | keys'
$ cat path/to/store.json | jq '.ownersByToken'
```

The former produces an array of all addresses that hold at least one NFT. Or you can simply further process the JSON yourself.

# License
The MIT License (MIT)

Copyright © 2025 Kiruse

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
