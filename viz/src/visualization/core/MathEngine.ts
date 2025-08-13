/**
 * Mathematical Engine for the Potion Problem
 * 
 * This engine provides all mathematical computations needed for the visualization,
 * including PMF calculations, simplex volumes, and Monte Carlo simulations.
 * 
 * Key features:
 * - Efficient factorial caching
 * - High-precision calculations for large n
 * - Validated against Lean 4 formalization
 */

export interface SimulationResult {
    count: number;
    values: number[];
    finalSum: number;
    cumulativeSums: number[];
}

export interface PMFPoint {
    n: number;
    probability: number;
    expectedContribution: number;
}

export class MathEngine {
    private static readonly E = Math.E;
    private static readonly MAX_FACTORIAL_CACHE = 170; // Beyond this, we get Infinity
    
    private factorialCache: Map<number, number>;
    private pmfCache: Map<number, number>;
    private logFactorialCache: Map<number, number>;
    
    constructor() {
        this.factorialCache = new Map([[0, 1], [1, 1]]);
        this.pmfCache = new Map();
        this.logFactorialCache = new Map([[0, 0], [1, 0]]);
    }
    
    /**
     * Compute n! with caching and overflow protection
     */
    factorial(n: number): number {
        if (n < 0 || !Number.isInteger(n)) {
            throw new Error(`Invalid factorial argument: ${n}`);
        }
        
        if (this.factorialCache.has(n)) {
            return this.factorialCache.get(n)!;
        }
        
        if (n > MathEngine.MAX_FACTORIAL_CACHE) {
            return Infinity;
        }
        
        let result = this.factorialCache.get(n - 1)! * n;
        this.factorialCache.set(n, result);
        return result;
    }
    
    /**
     * Compute log(n!) for numerical stability with large n
     */
    logFactorial(n: number): number {
        if (n < 0 || !Number.isInteger(n)) {
            throw new Error(`Invalid log factorial argument: ${n}`);
        }
        
        if (this.logFactorialCache.has(n)) {
            return this.logFactorialCache.get(n)!;
        }
        
        // Stirling's approximation for large n
        if (n > 100) {
            const result = n * Math.log(n) - n + 0.5 * Math.log(2 * Math.PI * n);
            this.logFactorialCache.set(n, result);
            return result;
        }
        
        let result = this.logFactorialCache.get(n - 1)! + Math.log(n);
        this.logFactorialCache.set(n, result);
        return result;
    }
    
    /**
     * Probability mass function: P(τ = n) = (n-1)/n!
     */
    pmf(n: number): number {
        if (n <= 1) return 0;
        
        if (this.pmfCache.has(n)) {
            return this.pmfCache.get(n)!;
        }
        
        let value: number;
        
        // For large n, use log-space computation
        if (n > 50) {
            const logValue = Math.log(n - 1) - this.logFactorial(n);
            value = Math.exp(logValue);
        } else {
            value = (n - 1) / this.factorial(n);
        }
        
        this.pmfCache.set(n, value);
        return value;
    }
    
    /**
     * Expected value E[τ] = Σ n·P(τ = n) = e
     */
    expectedValue(maxN: number = 100): number {
        let sum = 0;
        for (let n = 2; n <= maxN; n++) {
            const contribution = n * this.pmf(n);
            sum += contribution;
            
            // Stop when contributions become negligible
            if (contribution < 1e-15) break;
        }
        return sum;
    }
    
    /**
     * Volume of n-dimensional simplex: Vol(Δₙ) = 1/n!
     */
    simplexVolume(n: number): number {
        if (n > 50) {
            return Math.exp(-this.logFactorial(n));
        }
        return 1 / this.factorial(n);
    }
    
    /**
     * Generate a uniform random variable in [0,1)
     */
    generateUniform(): number {
        return Math.random();
    }
    
    /**
     * Simulate the hitting time process
     */
    simulateHittingTime(): SimulationResult {
        let sum = 0;
        let count = 0;
        const values: number[] = [];
        const cumulativeSums: number[] = [];
        
        while (sum < 1) {
            const value = this.generateUniform();
            sum += value;
            count++;
            values.push(value);
            cumulativeSums.push(sum);
        }
        
        return {
            count,
            values,
            finalSum: sum,
            cumulativeSums
        };
    }
    
    /**
     * Generate PMF data points for visualization
     */
    generatePMFData(maxN: number = 30): PMFPoint[] {
        const points: PMFPoint[] = [];
        
        for (let n = 2; n <= maxN; n++) {
            const probability = this.pmf(n);
            const expectedContribution = n * probability;
            
            points.push({
                n,
                probability,
                expectedContribution
            });
        }
        
        return points;
    }
    
    /**
     * Compute the partial sum of the expectation series
     */
    partialExpectation(n: number): number {
        let sum = 0;
        for (let k = 2; k <= n; k++) {
            sum += k * this.pmf(k);
        }
        return sum;
    }
    
    /**
     * Compute the telescoping series transformation
     * Shows how Σ n·(n-1)/n! transforms to Σ 1/k!
     */
    telescopingSeries(maxN: number = 20): {
        original: number[];
        transformed: number[];
        partial: number[];
    } {
        const original: number[] = [];
        const transformed: number[] = [];
        const partial: number[] = [];
        
        let sum = 0;
        
        for (let n = 0; n <= maxN; n++) {
            if (n < 2) {
                original.push(0);
                transformed.push(1 / this.factorial(n));
            } else {
                original.push(n * this.pmf(n));
                transformed.push(1 / this.factorial(n - 2));
            }
            
            sum += transformed[n];
            partial.push(sum);
        }
        
        return { original, transformed, partial };
    }
    
    /**
     * Monte Carlo estimation of E[τ]
     */
    monteCarloExpectation(trials: number = 10000): {
        estimate: number;
        standardError: number;
        samples: number[];
    } {
        const samples: number[] = [];
        
        for (let i = 0; i < trials; i++) {
            const result = this.simulateHittingTime();
            samples.push(result.count);
        }
        
        const mean = samples.reduce((a, b) => a + b, 0) / trials;
        const variance = samples.reduce((acc, x) => acc + (x - mean) ** 2, 0) / (trials - 1);
        const standardError = Math.sqrt(variance / trials);
        
        return {
            estimate: mean,
            standardError,
            samples
        };
    }
    
    /**
     * Compute the survival function: P(τ > n) = 1/n!
     */
    survivalFunction(n: number): number {
        if (n < 1) return 1;
        return this.simplexVolume(n);
    }
    
    /**
     * Compute the cumulative distribution function
     */
    cdf(n: number): number {
        if (n < 2) return 0;
        return 1 - this.survivalFunction(n);
    }
}