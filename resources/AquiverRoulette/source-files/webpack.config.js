const webpack = require('webpack');
const path = require('path');

const server = {
  entry: './src/server/server-roulette.ts',
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: ['ts-loader'],
        exclude: /node_modules/,
      },
    ],
  },
  plugins: [
    new webpack.DefinePlugin({ 'global.GENTLY': false }),
  ],
  optimization: {
    minimize: true,
  },
  resolve: {
    extensions: ['.tsx', '.ts', '.js'],
  },
  output: {
    filename: '../server/server-roulette.js',
    path: path.resolve(__dirname)
  },
  target: 'node',
};

const client = {
  entry: './src/client/client-roulette.ts',
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: ['ts-loader'],
        exclude: /node_modules/,
      },
    ],
  },
  optimization: {
    minimize: true,
  },
  resolve: {
    extensions: ['.tsx', '.ts', '.js'],
  },
  output: {
    filename: '../client/client-roulette.js',
    path: path.resolve(__dirname)
  },
};


module.exports = [server, client];