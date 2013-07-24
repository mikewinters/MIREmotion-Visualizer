(
// Initialization
s = Server.local;
s.boot;
b = Buffer.alloc(s, 44100 * 15.0, 1); // a four second 1 channel Buffer
)

b.free

( // For writing 16 soundfiles at (1,1), (1,3), (1,5), (1,7), (3,1)...
{
t = ("Working on (5:7,5:7)" ++ Date.getDate.format("-%Hh%M"));
d = Date.getDate.format("%d-%B-%Y");
f = ("~/Dropbox/Research/New System/SuperColliderTests"+/+d+/+t).standardizePath.mkdir;
7.do{|i|  // x's
	x = i+1;
	//x = 4;
		7.do{|j| // y's
		y = j+1;
		//y = 7;
			("x = "+x+" y = "+y).postln;
			z = Synth("mysynth22",[\bufnum, b, \valence, x, \activity, y]);
			15.2.wait;
			//b.write((f+/+j++"V"++x++"A"++y++".wav").standardizePath, sampleFormat: 'int16', headerFormat: "wav");
			b.write((f+/+"V"++x++"A"++y++".wav").standardizePath, sampleFormat: 'int16', headerFormat: "wav");
			"worked".postln;
		};
	};
"All Done".postln;
//"All Done!".speak;
{SinOsc.ar(440,mul:SinOsc.ar(40).range(0,3))*EnvGen.ar(Env.sine(5))}.play;
}.fork
)

(
{
Synth("mysynth22",[\bufnum, b, \valence, 1, \activity, 1]);
15.2.wait;
	b.write(("~/Dropbox/Research/New System/SuperColliderTests/that.wav").standardizePath, sampleFormat: 'int16', headerFormat: "wav");
	"Written".postln;
}.fork
)

((0..100)/30).collect(_.tanh).plot



(
History.start;
{
// The SynthDef
SynthDef(\mysynth22, { arg bufnum = 0, activity = 7, valence = 1;

var sound,
		devstr, shift, newact, newval, gainFunc, mul, compression1, compression2, offset1, offset2, offset3, offset4,
		frequencies, amplitudes, phases, modes, newval1, newact1, gomezthird, gomezfifth, tonalpower, offset5,
		value, gain, newact2, mul2,
		compression3, compression4, compression5,
		cutFreq, noiseamp1, noiseamp2, noise, pPoint, crossfadeContr, crossfadePos, quad2, sound1, noiseamp,
		rAct, rVal;

    	activity = LinLin.ar(activity,1,7,0,1);
		valence = LinLin.ar(valence,1,7,0,1);

		rAct = LinLin.ar(activity,0,1,-1,1);
		rVal = LinLin.ar(valence,0,1,-1,1);

		// Quadrant3: The Dynamic Profile
		devstr = 10;
		newact = 2*activity.clip2(0.5);  //clips activity above 0.5 to 1, and stretches 0-0.5 to 0-1.
		newval = 2*valence.clip2(0.5);
		shift = -8.8+(8.8*newact.pow(3));
		gainFunc = SinOsc.ar(0.4, mul:devstr, add:shift);
		mul = (gainFunc.tanh*0.5);  // Ranges from 0-1 or 0.48-0.52 // Have to spread out the range farther from V = 0;
		compression1 = 1-(0.5*newact.pow(0.5));//
		compression2 = compression1*(1-(0.88*newval));
		offset1=0.5; // centers the gain around 0.5
		offset2=0.14*newact.pow(0.05+(newval*0.95));//newact; // Now brings it back to a desired level
		offset3 = 0.01; // Makes sure in never goes to zero.
		offset4 = newval*(0.205 + (newact*0.057));
		offset2 = offset2+offset4;
		mul = (mul+offset1)*compression2+offset2+offset3;

		// Quadrant 4: Key Clarity
		frequencies = ([55, 59, 62]).midicps; // G Major \\\"closed\\\" chord starting on G3
		modes = frequencies.size;
		newval1 = 2*excess(valence,0.5);
		gomezthird = 0.91;
		gomezfifth = 0.99;
		tonalpower = 0.38*newval1.pow(0.6);
		amplitudes = ([1, gomezthird*tonalpower, gomezfifth*tonalpower]).normalizeSum;
		phases = nil;
		sound = DynKlang.ar(`[frequencies, amplitudes, phases]);
		offset5 = 0.09-(0.11*newact);
		mul = mul-(offset5*newval1);

        // Quadrant2: RMS
		newact2 = 2*excess(activity,0.5);
		mul = mul+(0.224*newact2);

		mul = mul+(0.10*newact2*((newval1*3).tanh));
		//mul = mul+(0.10*newact2*(newval1.roundUp).clip2(1));


		// Quadrant4:

/*
		noiseamp1 = 0.055*newact2.pow(0.66);
		noiseamp2 = (1-newval.pow(4));
		noise = noiseamp2*WhiteNoise.ar(noiseamp1);//Resonz.ar(WhiteNoise.ar(1),cutFreq,0.1);//HPF.ar(WhiteNoise.ar(0.1),5000);
		sound = sound+noise;
		compression3=1-(newact2.pow(0.05)*0.15);
		compression4=1+(0.4*newact2*newval);
		//compression5 = ((newval.linlin(0,1,0,pi).sin)*newact2.roundUp)*0.3;
		compression3 = (compression3*compression4);//-compression5;
		mul = mul+(newval*newact2.pow(0.25)*0.108);
		mul = mul*compression3;*/

		// newact2 = 2*excess(activity,0.5);
		// noiseamp1 = 0.055*newact2.pow(0.66);
		// noiseamp2 = (1-(newval.pow(1)));
		// noise = noiseamp2*WhiteNoise.ar(noiseamp1);//Resonz.ar(WhiteNoise.ar(1),cutFreq,0.1);//HPF.ar(WhiteNoise.ar(0.1),5000);
		// sound = sound+noise;
		// compression3=1-(newact2.pow(0.05)*0.15)+(0.15*(newval.pow(20))*(newact2.roundUp));
		// compression4=1+(0.4*newact2*newval);
		// compression3 = compression3*compression4;
		// mul = mul+(newval*newact2.pow(0.25)*0.108);
		// mul=mul*compression3;

		// Sound Output
		sound = sound*mul;

		// For recording purposes, lets keep the gain below 1.
		Poll.ar(sound>1,sound,\peak);
		Poll.ar(mul<0,mul,\dip);


    RecordBuf.ar(sound, bufnum, doneAction: 2, loop: 0);
	Out.ar(0,sound);
//}).play(s,[\\bufnum, b]);
}).add;

// Save this code as well
History.end;
("~/Dropbox/Research/New System/SuperColliderTests"+/+Date.getDate.format("%d-%B-%Y")).standardizePath.mkdir;
History.saveCS(("~/Dropbox/Research/New System/SuperColliderTests"+/+Date.getDate.format("%d-%B-%Y")+/+Date.getDate.format("%Hh%M")).standardizePath);
History.clear;
}.fork;
)

0.66.pow(0.4)*0.116




