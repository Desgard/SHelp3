import type { AppProps } from "next/app";
import "@fontsource/poppins";

function MyApp({ Component, pageProps }: AppProps) {
  console.log("hehe", Component)
  return <Component {...pageProps} />;
}

export default MyApp;
