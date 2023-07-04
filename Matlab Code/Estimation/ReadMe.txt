Step 1: Ensure whether the trained ML model is present in your working folder
Step 2: I have already pre-trained and loaded the model for the given speech samples in the training folder.
Step 3: Ensure the BiasedSigmoid Layer is also present. This is used as a separate layer inside the neural network.
Step 4: Now load the mixed speech signal of the same speakers for which the model had been trained. But it shoudl be of of shorter duration.
Step 5: Run the code, and it plays the male Speech alone.
Step 6: If you want you can save using audiowrite function.

