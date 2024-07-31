function dist=dtw_d(s1,s2,w,wt)

%INPUTS:
% s1: signal 1, size 1 * m * n. where m is the number of variables, n is the
% timesteps.
% s2: signal 2, size 1 * m * n. where m is the number of variables, n is the
% timesteps.
% w: window parameter, percent of size and is between0 and 1. if w is 0,
% return Euclidean distance
% wt: weight values
%OUTPUTS: 
% dist: resulting distance
%%    
    if length(size(s1)) ~=3 || length(size(s2))~=3
        error('Error in dtw(): dimensions of input sequence incorrect.');
    end
    if size(s1,2)~=size(s2,2)
        error('Error in dtw(): the number of variables do not match.');
    end
    if w<0 || w >1
        error('Error in dtw(): window size needs to be between 0 and 1.');
    end
    if w == 0
        %returns squared distance
        dist = squared_euclidean(s1,s2,wt);
        
        dist = sqrt(dist);
    else

        %get absolute window size
        w = ceil(w * size(s1,3));

        % adapt window size
        ns1=size(s1,3);
        ns2=size(s2,3);
        w=max(w, abs(ns1-ns2)); 

        %initialization
        D=zeros(ns1+1,ns2+1)+Inf; % cache matrix
        D(1,1)=0;
        for i=2:ns1+1
            for j=max(i-w,2):min(i+w,ns2+1)
                dist_temp = (squared_euclidean(s1(1,:,i-1),s2(1,:,j-1),wt));%squared euclidean distance between two points
                D(i,j)=dist_temp+min( [D(i-1,j), D(i,j-1), D(i-1,j-1)] );%find the optimal path
            end
        end
        % Initialize optimal path 
        optPath = struct('i', ns1+1, 'j', ns2+1); 
        path = []; 
        % Trace back from end to start
        while optPath.i > 1 && optPath.j > 1
            
            % Find min cost in neighborhood
            [minCost, idx] = min([D(optPath.i-1, optPath.j), D(optPath.i, optPath.j-1), D(optPath.i-1, optPath.j-1)]);
            
            % Update optimal path based on idx
            if idx == 1
                optPath = struct('i', optPath.i-1, 'j', optPath.j); 
            elseif idx == 2
                optPath = struct('i', optPath.i, 'j', optPath.j-1);
            else 
                optPath = struct('i', optPath.i-1, 'j', optPath.j-1);
            end
              % Store step  
            path = [path; optPath.i, optPath.j]; 
        end
        dist=sqrt(D(ns1+1,ns2+1));%return the square root of final distance
    end
end

function dist = squared_euclidean(s1,s2,wt)
%Inputs
% s1: signal 1, size 1 * m * n. where m is the number of variables, n is the
% timesteps.
% s2: signal 2, size 1 * m * n. where m is the number of variables, n is the
% timesteps.
% wt: weight value for each variable
%OUTPUT
%dist: Squared euclidean distance
%%
	dist = 0;%initilize
	%loop over each variable
	for ii=1:size(s1,2)
		
		ob1 = s1(1,ii);
		ob2 = s2(1,ii);
		ob = [ob1;ob2];
		%the final distance is the sum of squared distances of euclidean
		%distances
		dist = dist + wt(ii)*sum((ob(1,:) - ob(2,:)).^2);
	  
	end
end
 
