# L&L Blog Series - RAG Semantic Chunking Experiment

In this project, we will experiment and compare the results of an RAG application with context reranking versus no reranking.

The [experiment notebook](./rag_semantic_chunking/experiment_rag_semantic_chunking.ipynb) will implement and compare compare the simplest chunking method, fixed-size chunking, with the improvements offered by semantic chunking.

# &#127939; How do I get started?
If you haven't already done so, please read [DEVELOPMENT.md](DEVELOPMENT.md) for instructions on how to set up your virtual environment using Poetry.

## 💻 Run Locally

```bash
poetry shell
poetry install
poetry run jupyter notebook
```

Once the notebook is up, make sure you update the `FILE_PATH` parameter value. Once the correct file path is set, click `Run -> Run all cells` option.

It takes about 5 mins for everything to get completed if you have a Nvidia GPU. Otherwise, it will take about ~20-30 minutes.

Jump to the `Comparison` cell and toggle between different dropdown options to compare the results from various approaches.

# 💡 Background - Why do we chunk text?

When building a RAG (Retrieval-Augmented Generation) system, the first step is to create a knowledge base. This involves processing our data which is typically in the form of PDFs or books and storing it in a database for answering user questions later. If we simply ingest the raw text from these documents, we’re left with massive blocks of text.

Here’s the problem: language models have limits. They can’t process unlimited amounts of text at once, and there are two key reasons for this.

## Chunking Methods

### Fixed-size chunking

If you’re new to chunking and don’t know much about different strategies, a simple approach is to chunk text by a fixed character or word length. For example, if you have a document with 1,000 words, you could divide it into 10 chunks of 100 words each.

It’s probably the simplest method.

### Semantic Chunking

Instead of relying on arbitrary limits, we take an embedding-based approach, similar to how we build our database for document retrieval. Initially, we chunk the text using a naive method, then embed each chunk. The key idea is that we evaluate the embedding distances between chunks. If two chunks have embeddings that are close in distance, we group them together. If not, we leave them as separate chunks.

## The Process of Semantic Trunking

There isn’t a go to formula for semantic chunking just like there isn't a single best chunking strategy, it’s all about experimentation and iteration. The goal of semantic chunking is to make your data more valuable for your language model for your specific tasks.

However, we can start with a simple approach:

1. Split the document into sentences using punctuation (e.g., ., ?, !) or tools like spaCy or NLTK for more nuanced breaks.
2. Calculate distances between sentence embeddings.
3. Group similar sentences together or split sentences that aren’t similar.

What you will find in the [notebook](./rag_semantic_chunking/experiment_rag_semantic_chunking.ipynb) is the implementation of semantic chunking from scratch so that we can better understand how it works. You will also find an implementation of semantic chunking using LangChain which is probably what you will use in your project.

# Further Reading

- [Lunch & Learn Blog Series - Reranking]()
- [How to split text based on semantic similarity](https://python.langchain.com/docs/how_to/semantic-chunker/)
- [Chunking Strategies for LLM Applications](https://www.pinecone.io/learn/chunking-strategies/)
