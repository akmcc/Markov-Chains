Twitter bot via Markov chains/MetamorphoPlath
===============

MethamorphoPlath is a twitter bot that uses markov chains to generate sentences that are algorithmically similar to an input text file (in this case, a combination of Metamorphosis and Sylvia Plath poems). Sentences are created until it produces one that is 140 characters or less.

##TODOS:

1. Add a scoring system so that only 'interesting' or statistically likely sentences are tweeted. 
2. Find replacement for Treat gem or build own tokenizer as the tokenization process is tooo long.
3. Match punctuation in output, single parens and quotes get lonely.