function u = Ushapfilter_fix(D,eta)
%% U shap filter

% w = length(D);
% for i=1:w
%     a=1+(i/eta)^2;
%     b=1+((w-i)/eta)^2;
%     Ushapfilter(i)=1/sqrt(a)+1/sqrt(b);
% end

w = 1:length(D);
a=1+(w/eta).^2;
b=1+((length(D)-w)/eta).^2;
u = 1./sqrt(a) + 1./sqrt(b);

%  for j = 1:w
%      uw(j) = D(j)* Ushapfilter(j);
%  end
% uw = D .* Ushapfilter;
% u = uw';

