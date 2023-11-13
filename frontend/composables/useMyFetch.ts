export const useMyFetch: typeof useFetch = (request, opts?) => {
  const config = useRuntimeConfig();
  // console.log(opts);
  return useFetch(request, { baseURL: config.public.baseURL, ...opts });
};
