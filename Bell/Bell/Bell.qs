namespace Quantum.Bell
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Set (desired: Result, q1: Qubit) : ()
    {
        body
        {
            let current = M(q1);

			// if the qubut is in our desired state, we dont flip it
			if(desired != current)
			{
				// if the qubit is in the state that we dont want, then we flip it
				// using the X gate
				X(q1);
			}
        }
    }

	operation Playground (count : Int, initial: Result) : (Int, Int, Int)
	{
		body
		{
			mutable numOnes = 0;
			mutable agree = 0;
			using (qubits = Qubit[2])
			{
				for (test in .. count)
				{
					// set initial values to all qubits. Note that the initial values for the 2nd and 3rd qubit was given at random
					Set (initial, qubits[0]);
					Set (Zero, qubits[1]);
					Set (Zero, qubits[2]);
					// Make the probability of getting |1> or |0> for the first qubit effectively 50%
					H (qubits[0]);
					// Entangle our qubits
					CNOT (qubits[0], qubits[1]);
					CNOT (qubits[1], qubits[2]);
					let res = M(qubits[0]);
					// check if all qubits agree
					if (M(qubits[1]) == res == M(qubits[2]))
					{
						set agree = agree + 1;
					}
					if (res == One)
					{
						set numOnes = numOnes + 1;
					}
				}
				// set all qubits back to the ground state
				Set (Zero, qubits[0]);
				Set (Zero, qubits[1]);
				Set (Zero, qubits[2]);
			}
			// return the number of ones obtained, alongside how many times the three qubits were in agreement
			return (numOnes, count - numOnes, agree);
		}
	}

	// observe how the second qubit behaves in relation to the first qubit
	operation BellTest (count : Int, initial: Result) : (Int,Int,Int)
	{
		body
		{
			mutable numOnes = 0;
			// count the number of times when both the first and second qubit are in the same state
			mutable agree = 0;
			// allocate two qubits
			using (qubits = Qubit[2])
			{
				for (test in 1..count)
				{
					Set (initial, qubits[0]);
					Set (Zero, qubits[1]);

					H(qubits[0]);
					// CNOT entangles our two qubits
					CNOT(qubits[0], qubits[1]);
					let res = M (qubits[0]);

					// count the number of times the first and second qubit are in agreement
					// note that because our qubits are entangled, we should expect for both of our qubits to always be in the same state (100% agreement)
					if(M (qubits[1]) == res)
					{
						set agree = agree + 1;
					}

					// Count the number of ones we saw
					if (res == One)
					{
						set numOnes = numOnes + 1;
					}
				}
				// set both of our qubits back to the ground state for future computations
				Set(Zero, qubits[0]);
				Set(Zero, qubits[1]);
			}
			// Return number of times we saw |0> and number of times we saw a |1>. Also return the number of times the qubits agree with eachother
			return (count - numOnes, numOnes, agree);
		}
	}

	// Performs an X gate on a qubit in the desired initial state
	// Also measures the qubit once in the desired state
	operation XGate (count: Int, initial: Result) : (Int,Int)
	{
		body
		{
			mutable numZeros = 0;
			// use a single qubit
			using (qubits = Qubit[1])
			{
				for(test in 1..count)
				{
					Set (initial, qubits[0]);
					// performing this x operation flips our results, given that the X operator
					// flips qubit values over the "x axis"
					X(qubits[0]);
					let res = M(qubits[0]);
					if(res == Zero)
					{
						set numZeros = numZeros + 1;
					}
				}
				Set(Zero, qubits[0]);
			}
			// return the number of Zeros, then the numner of ones as a tuple
			return (numZeros, count - numZeros);
		}
	}

	operation HGate (count: Int, initial: Result) : (Int, Int)
	{
		body
		{
			mutable numZeros = 0;
			using (qubits = Qubit[1])
			{
				for(test in 1..count)
				{
					Set (initial, qubits[0]);
					// Say we want to flip the bit "halfway" instead of from 0 to 1 as in the X
					// gate. A Hadamard gate can perform this operation
					// A Hadamard gate, as used here, can be used to create a superposition of a qubit, for which the qubit is both |0> and |1> simultaneously
					H(qubits[0]);
					// measure the state of the qubit
					let res = M(qubits[0]);
					if(res == Zero)
					{
						set numZeros = numZeros + 1;
					}
				}
				// set the state of the qubit back to the ground state, so that it can be freely maniplated for future operations
				Set(Zero, qubits[0]);
			}
			return (numZeros, count - numZeros);
		}
	}
}
