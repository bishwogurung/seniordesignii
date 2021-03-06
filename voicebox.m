function y=voicebox(f,v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
persistent PP
if isempty(PP)

    % System-dependent directory paths and constants
 
     PP.dir_temp='F:\TEMP';                      % directory for storing temporary files
     PP.dir_data='E:\dmb\data\speech';           % default directory to preappend to speech data file names
     PP.shorten='C:\bin\shorten.exe';            % location of shorten executable
     PP.flac='C:\bin\flac.exe';                  % location of flac executable
     PP.sfsbin='F:\Program Files\SFS\Program';   % location of Speech Filing Sysytem binaries
     PP.sfssuffix='.exe';                        % suffix for Speech Filing Sysytem binaries
     PP.memsize=50e6;                            % Maximum amount of temporary memory to use (Bytes)
 
     % DYPSA glottal closure identifier
 
     PP.dy_cpfrac=0.3;           % presumed closed phase fraction of larynx cycle
     PP.dy_cproj=0.2;            % cost of projected candidate
     PP.dy_cspurt=-0.45;         % cost of a talkspurt
     PP.dy_dopsp=1;              % Use phase slope projection (1) or not (0)?
     PP.dy_ewdly=0.0008;         % window delay for energy cost function term [~ energy peak delay from closure] (sec)
     PP.dy_ewlen=0.003;          % window length for energy cost function term (sec)
     PP.dy_ewtaper=0.001;        % taper length for energy cost function window (sec)
     PP.dy_fwlen=0.00045;        % window length used to smooth group delay (sec)
     PP.dy_fxmax=500;            % max larynx frequency (Hz)
     PP.dy_fxmin=50;             % min larynx frequency (Hz)
     PP.dy_fxminf=60;            % min larynx frequency (Hz) [used for Frobenius norm only]
     PP.dy_gwlen=0.0030;         % group delay evaluation window length (sec)
     PP.dy_lpcdur=0.020;         % lpc analysis frame length (sec)
     PP.dy_lpcn=2;               % lpc additional poles
     PP.dy_lpcnf=0.001;          % lpc poles per Hz (1/Hz)
     PP.dy_lpcstep=0.010;        % lpc analysis step (sec)
     PP.dy_nbest=5;              % Number of NBest paths to keep
     PP.dy_preemph=50;           % pre-emphasis filter frequency (Hz) (to avoid preemphasis, make this very large)
     PP.dy_spitch=0.2;           % scale factor for pitch deviation cost
     PP.dy_wener=0.3;            % DP energy weighting
     PP.dy_wpitch=0.5;           % DP pitch weighting
     PP.dy_wslope=0.1;           % DP group delay slope weighting
     PP.dy_wxcorr=0.8;           % DP cross correlation weighting
     PP.dy_xwlen=0.01;           % cross-correlation length for waveform similarity (sec)
 
     % RAPT pitch tracker
 
     PP.rapt_f0min=50;           % Min F0 (Hz)
     PP.rapt_f0max=500;          % Max F0 (Hz)
     PP.rapt_tframe=0.01;        % frame size (s)
     PP.rapt_tlpw=0.005;         % low pass filter window size (s)
     PP.rapt_tcorw=0.0075;       % correlation window size (s)
     PP.rapt_candtr=0.3;         % minimum peak in NCCF
     PP.rapt_lagwt=0.3;          % linear lag taper factor
     PP.rapt_freqwt=0.02;        % cost factor for F0 change
     PP.rapt_vtranc=0.005;       % fixed voice-state transition cost
     PP.rapt_vtrac=0.5;          % delta amplitude modulated transition cost
     PP.rapt_vtrsc=0.5;          % delta spectrum modulated transition cost
     PP.rapt_vobias=0.0;         % bias to encourage voiced hypotheses
     PP.rapt_doublec=0.35;       % cost of exact doubling or halving
     PP.rapt_absnoise=0;         % absolute rms noise level
     PP.rapt_relnoise=2;         % rms noise level relative to noise floor
     PP.rapt_signoise=0.001;     % ratio of peak signal rms to noise floor (0.001 = 60dB)
     PP.rapt_ncands=20;          % max hypotheses at each frame
     PP.rapt_trms=0.03;                      % window length for rms measurement
     PP.rapt_dtrms=0.02;                     % window spacing for rms measurement
     PP.rapt_preemph=-7000;                  % s-plane position of preemphasis zero
     PP.rapt_nfullag=7;                      % number of full lags to try (must be odd)
     
     % now see if an environment variable has been set
     
     vbenv = winenvar('VOICEBOX');
     if exist(vbenv,'file');     % update with locally defined values if defined
         run(vbenv)
     end
 
     % now check some of the key values for validity
 
     if exist(PP.dir_temp,'dir')~=7        % check that temp directory exists
         PP.dir_temp = winenvar('temp');     % else use windows temp directory
     end
 
     [fnp,fnn,fne]=fileparts(mfilename('fullpath'));
     if exist(PP.shorten)~=2        % check that shorten executable exists
         PP.shorten=fullfile(fnp,'shorten.exe'); % next try local directory
         if exist(PP.shorten)~=2        % check if it exists in local directory
             PP.shorten='shorten.exe'; % finally assume it is on the search path
         end
     end
 
     if exist(PP.flac)~=2        % check that flac executable exists
         PP.flac=fullfile(fnp,'flac.exe'); % next try local directory
         if exist(PP.flac)~=2        % check if it exists in local directory
             PP.flac='flac.exe'; % finally assume it is on the search path
         end
     end
 
 end
 if nargin==0
     if nargout==0
         % list all fields
         nn=sort(fieldnames(PP));
         cnn=char(nn);
         fprintf('%d Voicebox parameters:\n',length(nn));
 
         for i=1:length(nn);
             if ischar(PP.(nn{i}))
                 fmt='  %s = %s\n';
             else
                 fmt='  %s = %g\n';
             end
             fprintf(fmt,cnn(i,:),PP.(nn{i}));
         end
     else
         y=PP;
     end
 elseif nargin==1
     if isfield(PP,f)
         y=PP.(f);
     else
         y=[];
     end
 else
     if isfield(PP,f)
         PP.(f)=v;
         y=PP;
     else
         error(sprintf('''%s'' is not a valid voicebox field name',f));
     end
 end