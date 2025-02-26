import type { NextPage } from "next";
import * as React from "react";
import { QueryClient, QueryClientProvider, QueryCache } from "react-query";
import { ChakraProvider, Box, Heading, Center } from "@chakra-ui/react";
import { Toaster, toast } from "react-hot-toast";
import theme from "../theme";
import { Provider as WagmiProvider } from "wagmi";
import { providers } from "ethers";
import Comments from "../components/Comments";

// Provider that will be used when no wallet is connected (aka no signer)
const provider = providers.getDefaultProvider("https://rpc-mumbai.maticvigil.com");

// Create a react-query client
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
    },
  },
  queryCache: new QueryCache({
    onError: () => {
      toast.error(
        "Network Error: Ensure Metamask is connected to the same network that your contract is deployed to."
      );
    },
  }),
});

const App: NextPage = () => {
  return (
    <WagmiProvider autoConnect provider={provider}>
      <ChakraProvider theme={theme}>
        <Box margin={20}>
          <Center>
            <Heading as='h3' size='xl'>
              疫情求助留言
            </Heading>
          </Center>
        </Box>
        <QueryClientProvider client={queryClient}>
          <Box p={8} maxW="600px" minW="320px" m="0 auto">
            <Comments topic="help-sh" />
            <Toaster position="bottom-right" />
          </Box>
        </QueryClientProvider>
      </ChakraProvider>
    </WagmiProvider >
  );
};

export default App;
