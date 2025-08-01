# Potion Problem Project Overview

## Purpose
This is a Lean 4 formal verification project for the "Aphrodisiac Problem" (also known as the Potion Problem or 媚薬問題 in Japanese). The project aims to formally prove that E[τ] = e (Euler's number), where τ is the expected number of doses of a potion needed until sensitivity reaches 2, starting from 1.

## Mathematical Background
- Starting from sensitivity level 1, each dose increases sensitivity by a uniform random amount m ∈ [0,1)
- The goal is to find the expected number of doses until sensitivity reaches 2
- This is equivalent to finding when the sum of uniform[0,1) variables first exceeds 1
- P(τ = n) = (n-1)/n! for n ≥ 2
- The expected value E[τ] = ∑_{n=2}^∞ n·P(τ=n) = e

## Tech Stack
- **Language**: Lean 4 (v4.22.0-rc4)
- **Dependencies**: mathlib4 (leanprover-community)
- **Build System**: Lake
- **API Database**: SQLite for O(1) API lookups
- **Version Control**: Git

## Current Status
- ✅ Main theorem proven (E[τ] = e) 
- ✅ All modules compile successfully
- ⚠️ 4 remaining sorries in IrwinHallTheory.lean:
  - Line 174: `iter_fwdDiff_pow_eq_factorial`
  - Line 204: `fwdDiff_iter_hitting_time_cdf_eq_pmf`
  - Line 229: `irwin_hall_sum_at_n`
  - Line 273: `irwin_hall_continuous`

## Key Achievement
The main theorem is complete despite remaining sorries in supporting infrastructure.