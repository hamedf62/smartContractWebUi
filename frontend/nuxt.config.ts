// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  modules: ["@element-plus/nuxt"],
  elementPlus: {
    /** Options */
  },
  // plugins: ["~/plugins/repository"],
  // server: {
  //   port: 5000,
  //   host: "127.0.0.1",
  // },
  buildModules: [
    // Simple usage
    "@nuxtjs/date-fns",

    // With options
    [
      "@nuxtjs/date-fns",
      {
        /* module options */
      },
    ],
  ],
  runtimeConfig: {
    public: {
      baseURL: process.env.BASE_URL || "http://127.0.0.1:5000/",
    },
  },
});
