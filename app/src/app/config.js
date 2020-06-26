const dev = {
  API: {
    BASE_URL: "h3hac79529.execute-api.eu-west-1.amazonaws.com/dev",
  },
};

const prod = {
  API: {
    BASE_URL: "h3hac79529.execute-api.eu-west-1.amazonaws.com/prod",
  },
};

return process.env.NODE_ENV === "production" ? prod : dev;