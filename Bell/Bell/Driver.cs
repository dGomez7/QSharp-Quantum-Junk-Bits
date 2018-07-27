using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.Bell
{
    class Driver
    {
        static void Main(string[] args)
        {
            // construct the quantum simulator
            using (var sim = new QuantumSimulator())
            {
                // Try initial values
                Result[] initials = new Result[] { Result.Zero, Result.One };
                foreach(Result initial in initials)
                {
                    // we pass the simulator, initial count of 1000, and an initial qubit value
                    // Note that the run method is asynchronous. 
                    // Each Q# operation has a corresponding C# class, for which a Run method belongs to the class
                    // the Run method performs asynchronous executions of the given operations
                    // note that our results for BellTest are strored in a tuple
                    var results1 = XGate.Run(sim, 1000, initial).Result;
                    // here we perform a Hadamard gate operation, for which our qubit is placed from the ground or exited state into
                    // a superposition state of either |0> or |1>
                    var results2 = HGate.Run(sim, 1000, initial).Result;
                    // Places two bits a Bell State, which is in essence a superposition of two qubits that are entangled
                    var res = BellTest.Run(sim, 1000, initial).Result;
                    // caste results into a tuple, for easy access
                    var (numZeros, numOnes, agree) = res;
                    var play = Playground.Run(sim, 1000, initial).Result;
                    var (nOnes, nZeros, agreement) = play;
                    // System.Console.WriteLine($"Init:{initial,-4} 0s={numZeros,-4} 1s={numOnes,-4} agree={agree, -4}");
                    System.Console.WriteLine($"Init:{initial,-4} 0s={nZeros,-4} 1s={nOnes,-4} agree={agreement,-4}");
                }
            }
            System.Console.WriteLine("Press any key to continue...");
            System.Console.ReadKey();
        }
    }
}