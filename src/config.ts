import { Apophis, Cosmos } from '@apophis-sdk/cosmos';
import { DefaultCosmWasmMiddlewares } from '@apophis-sdk/cosmwasm';

Apophis.use(...DefaultCosmWasmMiddlewares);
await Apophis.init();

export namespace networks {
  export const terra2 = Cosmos.getNetworkFromRegistry('terra2')
    .then(network => {
      network.endpoints = {
        rest: ['https://terra-lcd.publicnode.com'],
        rpc: ['https://terra-rpc.publicnode.com:443'],
        ws: ['wss://terra-rpc.publicnode.com:443/websocket']
      };
      return network;
    });
}
