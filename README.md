# XMR Stats

## Monero Block Explorer and Statistics

This is the project for the future _Open Source_ website **xmrstats.io**.

### Project Objectives

XMRStats aims to be a _Open Source and free of ADS_ website that offers *up to date* and *full historical* data about the Monero blockchain. It's aim is to help investors and enthusiasts to *analyze XMR usage*, offering _responsive charts_ to plot any data that they may find relevant, such as _average transactions per week_, per month, etc. You may want to see when a block with a high number of transactions show up, or transactions with many outputs, and plot everything together with the price action, being it XMRUSD or XMRBTC, XMRStats offers that too. Additionally, XMRStats will offer an API, in case you wish to download the data and use your own tools for analysis.

### Tools used

> Back end in Bash and PostgreSQL
Front End WebApp in GoLang.

### Project Scope

#### Website 

1. Display main recent XMR stats.

2. block height, difficulty, hashrate (growth - 7d- 30d), Price (growth 7d -30d), Transactions (growth - 7d-30d).

3. RSS Feed for high transaction counts/Other measures.

4. No ads, no payment.

#### Block explorer

1. Simple and responsive block explorer.

2. point click block data to chart.

#### API Request data

1. Have most data downloadable from api

2. Up to 1 hour candles

3. Look for blocks with specific parameters (high input transactions, high fees)

#### GitHub Project

1. API documentation

2. Chart documentation

#### Charts

1. Have most important block data:

    up to 1 hour chart

    block by block

    real time minute candles XMRUSD and XMRBTC

2. Display averages, EMAs

3. Hide one index/indicator

4. Volume

5. High input transaction indicators, high fee indicators.

6. Customizable indexes (XMRUSD/transactions, XMRBTC/transactions.

#### EXTRAS:

1. XMR Index going back all the way to 2014 (hourly) for XMRBTC and XMRUSD, using volume and data from different exchanges.

2. Monero Miner data (no. Miners)
