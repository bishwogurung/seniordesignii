 function fidx=writewav(d,fs,filename,mode,nskip,mask)
0002 %WRITEWAV Creates .WAV format sound files FIDX=(D,FS,FILENAME,MODE,NSKIP,MASK)
0003 %
0004 %   The input arguments for WRITEWAV are as follows:
0005 %
0006 %       D           The sampled data to save
0007 %       FS          The rate at which the data was sampled
0008 %       FILENAME    A string containing the name of the .WAV file to create or
0009 %                        alternatively the FIDX output from a previous writewav call
0010 %       MODE        String containing any reasonable mixture of flags below (*=default):
0011 %       NSKIP       Number of samples to skip before writing or -1[default] to continue from previous write
0012 %                   Only valid if FIDX is specified for FILENAME
0013 %       MASK        specifies the speaker positions included as a bit mask (see readwav)
0014 %
0015 % MODE flags (*=default):
0016 %  Precision: 'a'    for 8-bit A-law PCM
0017 %             'u'    for 8-bit mu-law PCM
0018 %            '16' *     for 16 bit PCM data
0019 %             '8'    for 8 bit PCM data
0020 %             ...    any number in the range 2 to 32 for PCM
0021 %             'v'    32-bit floating point
0022 %             'V'    64-bit floating point
0023 %             'c'    embed in 16 bits
0024 %             'C'    embed in 24 bits
0025 %             'L'    embed in 32 bits
0026 %      Dither: 'w'    White triangular dither of amplitude +-1 LSB (PCM modes only)
0027 %             'h'    High pass dither (filtered by 1-1/z) (PCM modes only)
0028 %             'l'    Low pass dither (filtered by 1+1/z) (PCM modes only)
0029 %    Scaling: 's' *  Auto scale to make data peak = +-1
0030 %             'r'    Raw unscaled data (integer values)
0031 %             'q'    Scaled to make unity mean square correspond to 0dBm according to G.711
0032 %             'p'       Scaled to make +-1 equal full scale
0033 %             'o'    Scale to bin centre rather than bin edge (e.g. 127 rather than 127.5 for 8 bit values)
0034 %                     (can be combined with n+p,r,s modes)
0035 %             'n'    Scale to negative peak rather than positive peak (e.g. 128.5 rather than 127.5 for 8 bit values)
0036 %                     (can be combined with o+p,r,s modes)
0037 %             'g'    Include a gain factor so that "readwav" will restore the correct level
0038 %     Offset: 'y' *     Correct for offset in <=8 bit PCM data
0039 %             'z'    Do not apply offset correction
0040 %     Format: 'x'    use WAVEFORMATEX format (default for non PCM)
0041 %             'X'    use WAVEFORMATEXTENSIBLE (default if MASK input is given)
0042 %             'e'    use original WAVEFORMAT (default for PCM)
0043 %             'E'    include a 'fact' chunk (default for non-PCM)
0044 %   File I/O: 'f'    Do not close file on exit
0045 %             'd'    Look in data directory: voicebox('dir_data')
0046 %
0047 %
0048 % Output Parameter:
0049 %
0050 %    FIDX     Information row vector containing the element listed below.
0051 %
0052 %           (1)  file id
0053 %            (2)  current position in file (in samples, 0=start of file)
0054 %           (3)  dataoff    length of file header in bytes
0055 %           (4)  nsamp    number of samples
0056 %           (5)  nchan    number of channels
0057 %           (6)  nbyte    bytes per data value
0058 %           (7)  bits    number of bits of precision
0059 %           (8)  code    Data format: 1=PCM, 2=ADPCM, 6=A-law, 7=Mu-law
0060 %           (9)  fs    sample frequency
0061 %           (10) dither state variable
0062 %           (11) gain in dB (in INST chunk)
0063 %
0064 %   Note: WRITEWAV will create an 16-bit PCM, auto-scaled wave file by default.
0065 %   For stereo data, d(:,1) is the left channel and d(:,2) the right
0066 %
0067 %   See also READWAV
0068 
0069 %   *** Note on scaling ***
0070 %   If we want to scale signal values in the range +-1 to an integer in the
0071 %   range [-128,127] then we have four plausible choices corresponding to
0072 %   scale factors of (a) 127, (b) 127.5, (c) 128 or (d) 128.5 but each choice
0073 %   has disadvantages.
0074 %   For forward scaling: (c) and (d) cause clipping on inputs of +1.
0075 %   For reverse scaling: (a) and (b) can generate output values < -1.
0076 %   Any of these scalings can be selected via the mode input: (a) 'o', (b) default, (c) 'on', (d) 'n'
0077 
0078 %       Copyright (C) Mike Brookes 1998-2011
0079 %      Version: $Id: writewav.m 713 2011-10-16 14:45:43Z dmb $
0080 %
0081 %   VOICEBOX is a MATLAB toolbox for speech processing.
0082 %   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
0083 %
0084 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0085 %   This program is free software; you can redistribute it and/or modify
0086 %   it under the terms of the GNU General Public License as published by
0087 %   the Free Software Foundation; either version 2 of the License, or
0088 %   (at your option) any later version.
0089 %
0090 %   This program is distributed in the hope that it will be useful,
0091 %   but WITHOUT ANY WARRANTY; without even the implied warranty of
0092 %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
0093 %   GNU General Public License for more details.
0094 %
0095 %   You can obtain a copy of the GNU General Public License from
0096 %   http://www.gnu.org/copyleft/gpl.html or by writing to
0097 %   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
0098 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0099 
0100 % Acknowledgements
0101 %   Thanks to Hugh Barnes for sorting out seek problems with MATLAB 6.5
0102 
0103 % Bugs/suggestions
0104 %  Save the following factors in FIDX: (a) scale factor, (b) offset (c) low/high clip limits
0105 %       (d) dither position  (e) rounding position
0106 
0107 
0108 if nargin<3
0109     error('Usage: WRITEWAV(data,fs,filename,mode,nskip)');
0110 end
0111 if nargin<6
0112     mask=0;
0113 end
0114 info=zeros(1,11);
0115 info(9)=fs;
0116 if nargin<4
0117     mode='s';
0118 else
0119     mode = [mode(:).' 's'];  % ensure that there is always a scaling option specified
0120 end
0121 info(8)=1;     % default mode is PCM
0122 mno=all(mode~='o');                      % scale to input limits not output limits
0123 k=find((mode>='0') & (mode<='9'),1);
0124 if k,
0125     info(7)=sscanf(mode(k:end),'%d');  % valid bits per data value
0126 else
0127     info(7)=16;
0128 end
0129 if any(mode=='c')
0130     info(6)=2;       % bytes per data value = 2
0131 elseif any(mode=='C')
0132     info(6)=3;       % bytes per data value = 3
0133 elseif any(mode=='L')
0134     info(6)=4;       % bytes per data value = 4
0135 else
0136     info(6)=ceil(info(7)/8);       % bytes per data value
0137 end
0138 lo=-pow2(0.5,info(7));
0139 hi=-1-lo;
0140 pk=pow2(0.5,8*info(6))*(1-(mno/2-all(mode~='n'))/lo);  % use modes o and n to determine effective peak
0141 % should perhaps have another variable besides info(7) to control dither position (or set info(7) later)
0142 % for A and mu law the dither position is not the same as the number of bits.
0143 if any(mode=='a')
0144     info(8)=6;
0145     pk=4032+mno*64;
0146     info(7)=8;  % Some sources say this should be listed as 16 valid bits
0147     info(6)=1;
0148 elseif any(mode=='u')
0149     info(8)=7;
0150     pk=8031+mno*128;
0151     info(7)=8;  % Some sources say this should be listed as 16 valid bits
0152     info(6)=1;
0153 elseif any(mode=='v')
0154     pk=1;
0155     mode(end)='r';  % default scaling is 'r'
0156     info(6)=4;  % bytes
0157     info(7)=32; % bits
0158     info(8)=3;  % WAVE type
0159 elseif any(mode=='V')
0160     pk=1;
0161     mode(end)='r';   % default scaling is 'r'
0162     info(6)=8; % bytes
0163     info(7)=64; % bits
0164     info(8)=3; % WAVE type
0165 end            % is this pk value correct ?
0166 sc=mode(find((mode>='p') & (mode<='s'),1)); % find the first scaling option (always exists)
0167 z=128*all(mode~='z');
0168 if any(mode=='w')
0169     di='w';                       % select dither mode
0170 elseif any(mode=='h')
0171     di='h';
0172 elseif any(mode=='l')
0173     di='l';
0174 else
0175     di='n';
0176 end
0177 
0178 % Now sort out which wave format to use
0179 if any(mode=='e')
0180     wavtype=1;
0181 elseif any(mode=='x')
0182     wavtype=2;
0183 elseif any(mode=='X') || nargin>=6
0184     wavtype=3;
0185 else
0186     wavtype=2-(info(8)==1);
0187 end
0188 wavfmt=info(8)*(wavtype<3)+(pow2(16)-2)*(wavtype==3);
0189 fmtlen=[16 18 40]; % length of format chunk
0190 factlen=12*(any(mode=='E') || info(8)~=1);
0191 instlen=16*any(mode=='g');  % length of INST chunk (force to be even since some readers do not like odd lengths)
0192 wavlen=[36 38 60]+factlen+instlen; % length of entire WAVE chunk except for the data (not including 8 byte RIFF header)
0193 
0194 
0195 [n,nc]=size(d);
0196 if n==1
0197     n=nc;
0198     nc=1;
0199 else
0200     d = d.';
0201 end;
0202 if nc>32
0203     error('WRITEWAV: attempt to write a sound file with >32 channels');
0204 end
0205 nc=max(nc,1);
0206 ncy=nc*info(6);                     % bytes per sample time
0207 nyd=n*ncy;                          % bytes to write
0208 
0209 if ischar(filename)
0210     if any(mode=='d')
0211         filename=fullfile(voicebox('dir_data'),filename);
0212     end
0213     ny=nyd;
0214     if isempty(findstr(filename,'.'))
0215         filename=[filename,'.wav'];
0216     end
0217     fid=fopen(filename,'wb+','l');
0218     if fid == -1
0219         error('Can''t open %s for output',filename);
0220     end
0221     info(1)=fid;
0222     fwrite(fid,'RIFF','uchar');  % main RIFF header
0223     fwrite(fid,wavlen(wavtype)+2*ceil(ny/2),'ulong');  %
0224     fwrite(fid,'WAVEfmt ','uchar');   % write "WAVE" ID and "fmt" chunk
0225     fwrite(fid,[fmtlen(wavtype) 0 wavfmt nc],'ushort'); % chunk size, format code, number of channels
0226     fwrite(fid,[fs fs*ncy],'ulong');        % sample rate, bytes per sec
0227     switch wavtype
0228         case 1
0229             fwrite(fid,[ncy info(7)],'ushort');     % block size, bits-per-sample
0230         case 2
0231             fwrite(fid,[ncy info(7)],'ushort');     % block size, bits-per-sample
0232             fwrite(fid,0,'ushort');     % size of the extension=0
0233         case 3
0234             fwrite(fid,[ncy 8*info(6)],'ushort');     % block size, bits-per-sample (aways a multiple of 8)
0235             fwrite(fid,[22 info(7)],'ushort');     % size of the extension=22, valid bits
0236             fwrite(fid,[mask info(8)],'ulong');        % speaker position mask, encoding format
0237             fwrite(fid,[0 16 128 43520 14336 29083],'ushort');                % GUID
0238     end
0239     if factlen
0240         fwrite(fid,'fact','uchar');   % fact chunk header
0241         fwrite(fid,[4 n],'ulong');       % length in bytes + number of samples
0242     end
0243     if instlen
0244         fwrite(fid,'inst','uchar');   % fact chunk header
0245         fwrite(fid,instlen-8,'ulong');       % length in bytes
0246         fwrite(fid,zeros(1,instlen-8),'uchar');   % inst data (zero for now)
0247     end
0248     fwrite(fid,'data','uchar');   % data header
0249     fwrite(fid,ny,'ulong');       % data length in bytes
0250     nskip=0;                        % over-ride any nskip argument
0251     info(3)=8+wavlen(wavtype);      % length of all header information
0252     info(4)=n;                      % number of samples (per channel)
0253     info(2)=n;                      % current file position (in samples)
0254     info(10)=rand(1);                       % seed for dither generation
0255 else
0256     info=filename;
0257     fid=info(1);
0258     fseek(fid,0,1); % go to end of file
0259     if nargin<5 || nskip<0
0260         nskip=info(2);                      % use previous high water mark
0261     end
0262     info(2)=n+nskip;                          % file position following this write operation (in samples)
0263     ny=nyd+nskip*ncy;                       % file position following this write operation (in bytes following header)
0264     if n && (info(2)>info(4))               % update high water mark
0265         if ~info(4)                           % if no data written previously
0266             fseek(fid,22,-1); fwrite(fid,nc,'ushort');   % update number of channels
0267             fseek(fid,28,-1); fwrite(fid,fs*ncy,'ulong'); % update bytes/second
0268             fwrite(fid,ncy,'ushort'); % update bytes/sample
0269         end
0270         fseek(fid,4,-1); fwrite(fid,wavlen(wavtype)+2*ceil(ny/2),'ulong'); % update RIFF length
0271         if factlen
0272             fseek(fid,wavlen(wavtype)-4-instlen,-1); fwrite(fid,n,'ulong');  % update FACT number of samples
0273         end
0274         fseek(fid,4+wavlen(wavtype),-1); fwrite(fid,ny,'ulong');  % update DATA length
0275         info(4)=info(2);
0276     end
0277 end
0278 info(5)=nc;
0279 
0280 if n
0281 
0282     if sc~='r'                  % 'r' = no scaling
0283         if sc=='s'              % 's' = scale to peak signal
0284             pd=max(abs(d(:)));
0285             pd=pd+(pd==0);      % scale to 1 if data is all zero
0286         elseif sc=='p'          % 'p' = scale to +-1 = full scale
0287             pd=1;
0288         else                    % 'q' = scale to 0dBm
0289             if info(8)==7       % mu-law
0290                 pd=2.03761563;
0291             else                % A-law or anything else
0292                 pd=2.03033976;
0293             end
0294         end
0295         if instlen
0296             info(11)=min(max(ceil(20*log10(pd)),-128),127);
0297             d=pk*10^(-0.05*info(11))*d;    
0298             if fseek(fid,0,-1)  % MATLAB V6.5 fails if this is omitted
0299                 error('Cannot rewind file');
0300             end
0301             if fseek(fid,info(3)-instlen+2,-1);
0302                 error('Cannot seek to INST chunk gain byte');
0303             end
0304             fwrite(fid,info(11),'schar');   % write the INST gain in dB
0305         else
0306             d=pk/pd*d;
0307         end
0308     end
0309     if fseek(fid,0,-1)  % MATLAB V6.5 fails if this is omitted
0310         error('Cannot rewind file');
0311     end
0312     if fseek(fid,info(3)+nskip*nc*info(6),-1)
0313         error('Cannot seek to byte %d in output file',info(3)+nskip*nc*info(6));
0314     end
0315     if info(8)==3 % floating point
0316         if info(6)==4
0317             fwrite(fid,d,'float32');
0318         else
0319             fwrite(fid,d,'float64');
0320         end
0321     else                        % integer data
0322         if info(8)<6            % PCM
0323             if di=='n'
0324                 d=round(d);
0325             else
0326                 [d,info(10)]=ditherq(d,di,info(10));
0327             end
0328             d=min(max(d,lo),hi)*pow2(1,8*info(6)-info(7));       % clip data and shift to most significant bits
0329         else                    % mu or A law
0330             z=0;
0331             if info(8) < 7
0332                 d=lin2pcma(d,213,1);
0333             else
0334                 d=lin2pcmu(d,1);
0335             end
0336         end
0337         if info(6)<3
0338             if info(6)<2
0339                 fwrite(fid,d+z,'uchar');
0340             else
0341                 fwrite(fid,d,'short');
0342             end
0343         else
0344             if info(6)<4
0345                 d=d(:)';
0346                 d2=floor(d/65536);
0347                 d=d-65536*d2;
0348                 fwrite(fid,[rem(d,256); floor(d/256); d2+256*(d2<0)],'uchar');
0349             else
0350                 fwrite(fid,d,'long');
0351             end
0352         end
0353         if rem(ny,2) % pad to an even number of bytes
0354             fwrite(fid,0,'uchar');
0355         end
0356     end
0357 end
0358 if all(mode~='f')
0359     fclose(fid);
0360 end
0361 if nargout
0362     fidx=info;
0363 end