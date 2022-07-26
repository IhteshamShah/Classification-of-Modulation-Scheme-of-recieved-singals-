%%%%%%%%%%%%%%%%%%%%%  Cuckoo Search Algorithm  %%%%%%%%%%%%%%%%%%%%

close all
clear all
clc
rng('shuffle')

%%              `   Paramter Initialization

n=40;                           % Number of Nests;
Iteration=10:10:50;            % Number of Iterations
R=eye(n);                       %
R(2:n+1:end)=0.2;               %
R(n+1:n+1:end)=0.2;             % Co-Relation Matrix
SNR=[0 5 10 20 30];                         % Signal to Noise Ratio

for sn=1:length(SNR)
test=10;                        % Number of Averages
s=randsrc(1,n);                 % Randomly Generate Signal
r=awgn(s,SNR(sn));                  % Recieved Signal
Pa=0.25;                         % Probability of detecting Cuckoo's egg
beta=1.5;                       % Step size
F1=zeros(1,n);F2=F1;
F3=F1;F4=F1;
New_Sol=zeros(n);
% avg_error=zeros(1,length(Iteration));
Next_gen=New_Sol;
% err=zeros(1,test);

for ax=1:length(Iteration)
    nests=randsrc(n);               % Initial Solutions

for xx=1:test

%%                       Fitness Function
for iter=1:Iteration(ax)

for i=1:n
    F1(i)=2*nests(i,:)*r'-nests(i,:)*R*(nests(i,:)');
end

%%                    Concatenation and Sorting
Z1=[F1',nests];
Z2=flip((sortrows(Z1)),1);
Gb=Z2(1,2:end);

%%               Update Cuckoo's by Levy Flights

sigma=((gamma(1+beta)*sin(pi*beta/2))/(gamma(((1+beta)/2)*beta*(2^((beta-1)/2)))))^(1/beta);

for k1=1:n
    s1=nests(k1,:);
%%% Levy flights by Mantegna's algorithm
    u=randn(size(s1))*sigma;
    v=randn(size(s1));
    step=u./abs(v).^(1/beta);
    stepsize=1*step.*(s1-Gb);
    s1=s1+stepsize.*randn(size(s1));
    New_Sol(k1,:)=sign(s1);clear s1;
% a2=s1*randn;b=randn;
% step=a1./abs(b).^(1/b1);
% step_size=1*step.*(nests(k1,k2)-Gb(1,k2));
% New_Sol(k1,k2)=nests(k1,k2)+step_size.*randn;
end

for i1=1:n
    F2(i1)=2*New_Sol(i1,:)*r'-New_Sol(i1,:)*R*(New_Sol(i1,:)');
end

%%                    Concatenation and Sorting
Z3=[F2',New_Sol];
Z4=flip((sortrows(Z3)),1);
% Gb1=Z4(1,2:end);

%%                      Greedy Selection
for k3=1:n
if Z3(k3,1)>Z1(k3,1)
    Next_gen(k3,:)=Z3(k3,2:end);
else
    Next_gen(k3,:)=Z1(k3,2:end);
end
end 

for i3=1:n
    F3(i3)=2*Next_gen(i3,:)*r'-Next_gen(i3,:)*R*(Next_gen(i3,:)');
end

%%                    Concatenation and Sorting
Z5=[F3',Next_gen];
Z6=flip((sortrows(Z5)),1);
% Gb2=Z6(1,2:end);

%%                      `Alien Egg Discovery
K=rand(size(Next_gen))>Pa;
% ns1=Next_gen(randperm(n),:);
% ns2=Next_gen(randperm(n),:);
% stepsize=rand(n).*(ns1-ns2);
% final_gen=Next_gen+stepsize.*K;
% final_gen=sign(final_gen)

%% New solution by biased/selective random walks
clear stepsize;
stepsize=randn(n).*(Next_gen(randperm(n),:)-Next_gen(randperm(n),:));
final_sol=Next_gen+stepsize.*K;
final_sol=sign(final_sol);
% for j3=1:size(final_sol,1);
%     s2=final_sol(j3,:);
%   final_sol(j3,:)=sign(s2);clear s2;
% end

% nestn1=nest(randperm(n),:);
% nestn2=nest(randperm(n),:);
% %% New solution by biased/selective random walks
% stepsize=rand*(nestn1-nestn2);
% new_nest=nest+stepsize.*K;
% for j=1:size(new_nest,1)
%     s=new_nest(j,:);
%   new_nest(j,:)=simplebounds(s,Lb,Ub);  
% end

for i4=1:n
    F4(i4)=2*final_sol(i4,:)*r'-final_sol(i4,:)*R*(final_sol(i4,:)');
end

%%                    Concatenation and Sorting
Z7=[F4',final_sol];
Z8=flip((sortrows(Z7)),1);
Gb2=Z8(1,2:end);
nests=Z8(1:end,2:end);
end                    % Iter loop
    error=0;
for mi=1:n
    if s(1,mi)~=Gb2(1,mi)
        error=error+1;
    end
end
err(xx)=error;
end                    % test loop
avg_error(ax)=(sum(err)/test);

end

a_e_snr(sn,:)=avg_error
end 



% plot(smooth(smooth(SNR,(a_e_snr(1,:)))))
hold on 
plot(smooth(smooth(SNR,(a_e_snr(2,:)))))
hold on 
plot(smooth(smooth(SNR,(a_e_snr(3,:)))))
hold on 
plot(smooth(smooth(SNR,(a_e_snr(4,:)))))
hold on 
plot(smooth(smooth(SNR,(a_e_snr(5,:)))))







% Iterations loop