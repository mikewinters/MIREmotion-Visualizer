Some visualizer tools for designing sonifications of emotion using the miremotion function from MIRToolbox.  Created as part of my masters thesis:

"Exploring Music through Sound: Sonification of Emotion, Gesture, and Corpora"

at McGill University.  As of today (7/24/2013), everything is working well on MacOSX 10.7.5 and Matlab2012_a.  

%%%%%%%%%%%%%%%%%%%
INSTRUCTIONS:

MYEMOTION

To run the myemotion visualizer do this:

1) Set path in Matlab to include this entire folder
2) Open myemotion.m and find the handles.directory variable.  Replace it with the desired save directory
3) Run myemotion('this') in Matlab where 'this' is a .wav file in your directory.

If it is successful, it will ask you for a title.  If you leave it "untitled," nothing will be saved.  I suggest giving the most descriptive title possible.  Giving a title will also save a .wav file with the same name.  Every graph you view is automatically saved as well in a folder with the same name as your title, in another folder which is today's date.


AVMAP

To run avmap, make sure you have followed step 1 above.  Then cd in MATLAB into a directory with a bunch of .wav files labelled according to the scheme A1V1, A1V2, A2V1, etc. where the number is an integer between 1 and 7.  Make sure there are no other .wav files in the directory.  Once that has been done, simply run avmap and the visualizer will run.

%%%%%%%
Little extras you might not be aware of.

-Double clicking on a point in the avmap will play the sound file that was analyzed
-Clicking 'detail' in the avmap visualizer runs myemotion on the selected soundfile.
-In the ExampleOutput directory, you will find SuperCollider code that can be used to generate almost perfectly measured sound files for 49 equally distributed points in the AV space.  Created on SuperCollider 3.6.3.  Make sure you change the directory in the code.  

%%%%%%%%%
Things to do:
7/24/2013

-Better comments (sorry, but some just won't make sense right now both in the MATLAB and SC code)
-Do the rest of the emotions (not just activity and valence)
-Make it so that one can transfer a folder with a .fig file (from avmap) and still have it play individual files when double clicked.  

%%%%%%%
Final thoughts:

I hope that more tools for music emotion recognition become publicly available in the future and that sonification of emotion continues to make use of them for design and evaluation, conscious of the psychological mechanisms evoked by the cues, and their psychological properties (low induction speed, low cultural influence, low volitional influence).


