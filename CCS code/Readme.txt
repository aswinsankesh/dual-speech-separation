This folder consists of all things needed for implementing this code in Real-time.

1. The folder 'CCS project folder' was the CCS project file, which you can directly load it in Code Composer Studio.
Or else you can see the Main program 'DSP c code' in this folder, with which you can form your new project.

2. Also the Binary Mask for extracting the female voice has been generated with the neural network in MATLAB and then given it here.
You can find it in the form of 'binMask_hello.h' file. Load this to your project.

3. Here are the audio files for checking it in real-time. 
You can see that while playing hello_mixed, eventhough it is a mixed signal, you will hear the female speech alone.

Note: before building the code check you have all support files linked to your corresponding directory correctly. Or else the code may not run.
You can verify this by going to properties and include options and file search path.


