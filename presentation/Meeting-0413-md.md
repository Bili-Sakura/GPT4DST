---
marp: true
---

# GPT4DST Meeting

- Topic: Paper Reading & Paper Discussion
- Date: 2024.04.13(Sat.)

---

## [SPRING: Studying the Paper and Reasoning to Play Games](https://arxiv.org/abs/2305.15486) (NeurIPS2023)

> GitHub: <https://github.com/holmeswww/spring>

![SPRING: Studying the Paper and Reasoning to Play Games](./assets/SPRING/Arvix.png)

---

## Overview of `SPRING`

![Overview](./assets/SPRING/Figure1.png)

---

## Introduction

### Background

Open-world survival games: Minecraft ([Fan et al., 2022](https://arxiv.org/abs/2206.08853)) and Crafter ([Hafner, 2021]((https://arxiv.org/abs/2109.06780)))

### Challenges

- procedural generation requires strong generalization
- diverse action space requires **multi-task capabilities**
- technology tree requires **long-term planning** and deep exploration
- diverse and conflicting objectives requires **goal prioritization**

---

## Introduction

> Reinforcement learning (RL) has been the go-to approach for game-based problems, with numerous successes in games like Go ([Silver et al., 2017]((https://www.nature.com/articles/nature24270))), robotics ([Fu et al., 2020;](https://arxiv.org/abs/2004.07219) [Hafner et al., 2023](https://arxiv.org/abs/2301.04104)) and various video games ([Vinyals et al., 2019;](https://www.nature.com/articles/s41586-019-1724-z)) ([Schrittwieser et al., 2020;](https://www.nature.com/articles/s41586-020-03051-4) [Badia et al., 2020;](https://arxiv.org/abs/2003.13350)[Hafner et al., 2023](https://arxiv.org/abs/2301.04104)).

**Limitation of RL: high sample complexity & incompatibility with prior knowledge**

> LLMs serve as a candidate for incorporating prior knowledge and in-context reasoning for game-based problems, particularly when it comes to addressing the aforementioned limitations of RL.
---

## Introduction

### Main Contributions

• SPRING is the first to tackle a competitive RL benchmark by explicitly extracting multiple interactions and tech-tree dependencies directly from an academic paper.
• We are the first to show SOTA performance in a challenging open world game with a zero-shot LLM-based (GPT-4) policy
• We study the quality of in-context “reasoning” induced by different prompts and propose a controlled chain-of-thought prompting through a DAG of questions for decision making.

> Notes: benchmark; interactions; tech-tree; zero-shot; COT; DAG

---

## Method

### Studying the paper: Context from LATEX source

![Figure2](./assets/SPRING/Figure2.png)

---

## Method: Reasoning

![Figure3](./assets/SPRING/Figure3.png)

---

## Results and Evaluation: RL Baseline

![Table2](./assets/SPRING/Table2.png)

---

## Results and Evaluation: Overall Results

![Figure4](./assets/SPRING/Figure4.png)

---

## Related Work

### Paper (Core References)

> First Author: Danijar Hafner (Google Researcher/DeepMind)

[Mastering Atari with Discrete World Models](https://arxiv.org/abs/2010.02193) (ICLR2021)

[Benchmarking the Spectrum of Agent Capabilities](https://arxiv.org/abs/2109.06780) (ICLR2022)

[Mastering Diverse Domains through World Models](https://arxiv.org/abs/2301.04104) (Arvix2023)

### Code

SmartPlay: <https://github.com/microsoft/SmartPlay>
> SmartPlay is a `benchmark` for Large Language Models (LLMs). Uses a variety of games to test various important LLM capabilities as agents. SmartPlay is designed to be easy to use, and to support future development of LLMs.

---

## Take-Home Notes

1. Agent + Knowledge > Reinforcement Learning
2. GPT-4 outperforms other foundation models in reasoning.
3. High quality corpus of domain-specified knowledge is demanded.
4. Compared to previous works on open-world survival game playing agents such as `Minecraft`/`Crafter`/`...`, we are the **pioneers** who implement LLM/Agent on `Don't Starve Together(DST)`. Moreover, `DST` seems to be the only survival game whose environmental variables is available for researchers/developers.

---

## Conception of Our Paper

### DST-Agent: Perception-Based Agent in a Difficult Survival Game

> **Perception** + Inference + Action Execution (Loop/Cycle/Iteration)

---

### Abstract (demo ver.)

Open-world survival games pose significant challenges for AI algorithms. Current works use vision-language models to understand and interact with environment, which demands high computational resources. Don't Starve Together(DST) is a develop-free open world survival game, where environmental variables is available for mod developer. Given the convenience of DST, We propose DST-Agent, an agent whose instruction is deeply integrated with game environment variables by deploying it as an in-game workshop mod. Our DST-Agent framework employs a directed acyclic graph (DAG) with game-related questions as nodes and dependencies as edges. We identify the optimal action to take in the environment by traversing the DAG and calculating LLM responses for each node in topological order, with the LLM’s answer to final node directly translating to environment actions. Our experiments suggest that LLMs, when prompted with consistent chain-of-thought, have great potential in completing sophisticated high-level trajectories.Quantitatively, DST-Agent with GPT-4 outperforms all state-of-the-art RL baselines, trained for 1M steps, without any training. 
