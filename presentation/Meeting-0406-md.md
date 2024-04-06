---
marp: true
---

# GPT4DST: Interact with AI Pro-Gamer in Don't Starve Together

![logo](../assets/logo_1.jpg)

---

## Introduction

GPT4DST is a secondary development application based on the langchain library calling OpenAI's large language model. The project aims to provide an intelligent interactive experience for the Don't Starve Together (DST) game by developing specialized mods to interact with players.

---

## Quick Start

## Data

### ~~Further Pretrain Data~~

### ~~Instruction Tuning: DSTSignal~~

### ~~Benchmark: DSTBench~~

## Code

### ~~Further Pretrain Configurations~~

### ~~Fine-Tuning~~

---

## Cases

## Evaluation

## Contributors

## Acknowledgements

## License

## Citation

---

## Developer Notes

DATA COLLECTION AND CURATION

- [ ] Collect `Raw DST Knowledge` from Wiki Fandom using API
- [ ] Clean `Raw DST Knowledge` into `Formatted DST Knowledge`/`Structured DST Knowledge`
- [ ] Construct pipeline for creating `DSTSignal`/`DSTBench`

LLM DOMAIN SPECIFIED USING RAG

- [ ] Consolidate `DST Knowledge` into vectorstore using `Chroma`/`Milvus`/...
- [ ] Implement RAG to enhance LLM capabilities using `langchain`/`llamaindex`/...
- [ ] Implement adavanced RAG techniques

---

DEPLOYMENT WITH WEBPAGES

- [ ] Deployment project using `Vue`/`React`/`Streamlit`

DEPLOYMENT WITH API

- [ ] Deployment project using `FASTAPI`

INTERACTION WITH ENVIRONMENT USING AGENT

- [ ] Import llm modules into the DST mod
- [ ] Achieve simple QA in DST

---

## Outline of Scientific Writing

> Paper Title: DST-Agent: Intelligent Game Playing Guidance by Empowering Large Language Models with Environment Interaction  
> Abstract: ...  
> Main Contributions: DSTBench & DSTSignal ; Reinforcement Learning for Environment Interaction ; Integrating in Game

---

INTRODUCTION & RELATED WORK

- Introduction to LLMs
  - [A Survey of Large Language Models](https://arxiv.org/abs/2303.18223)
- Knowledge Injection
  - [Fine-Tuning or Retrieval? Comparing Knowledge Injection in LLMs](https://arxiv.org/abs/2312.05934)
  - [Retrieval-Augmented Generation for Large Language Models: A Survey](https://arxiv.org/abs/2312.10997)
- Game Playing Agent
  - [A Survey on Game Playing Agents](https://arxiv.org/abs/2403.10249)
  - [PokeLLMon: A Human-Parity Agent for Pokemon Battles with Large Language](https://arxiv.org/abs/2402.01118)
  - [SPRING: Studying the Paper and Reasoning to Play Games](https://arxiv.org/abs/2305.15486)

---

DATA COLLECTION AND CURATION

- Pipeline of DSTSignal & DSTBench

KNOWLEDGE INJECTION

- Retrival-Augmented Generation(RAG)
- Chain of Thought (COT)/Tree of Thought(TOT)/Chain of Abstraction(COA)

REINFORCEMENT LEARNING FOR ENVIRONMENT INTERACTION

---

AGENT

- Reasoning and Act(ReACT)

CASES STUDY

EVALUATION AND RESULTS

CONCLUSION
