classdef SymbolicSingleBlock
    % Wrapper around a single symbolic matrix.
    % Acts as a single block for SymbolicBlockMatrix.
    %

    properties
        sm % underlying symbolicmatrix
    end

    methods
        % Constructor
        function obj = SymbolicSingleBlock(sm)
            % Construct an instance of this class
            if isa(sm, "symmatrix")
                obj.sm = sm;
            else
                error("Wrong input type: should be 'symmatrix'.")
            end

        end


        % Overloading operators
        function result = plus(obj1, obj2)
            % do multiplication
            % create output symmatrix
            result_sm = obj1.sm + obj2.sm;
            result = SymbolicSingleBlock(result_sm);
        end

        function result = minus(obj1, obj2)
            % do multiplication
            % create output symmatrix
            result_sm = obj1.sm - obj2.sm;
            result = SymbolicSingleBlock(result_sm);
        end

        function result = mtimes(obj1, obj2)
            % do multiplication
            % create output symmatrix
            result_sm = obj1.sm * obj2.sm;
            result = SymbolicSingleBlock(result_sm);
        end

        function obj = ctranspose(obj)
            obj_orig_copy = obj; % new object is created (deep copy)
            obj.sm = obj_orig_copy.sm';
        end
        
        function [result] = eq(obj1, obj2)
            result = (obj1.sm == obj2.sm); % parentheses are for readability
        end
% To be implemented (maybe, because maybe cell2mat should only return numerical-valued matrix)        
%         function result = cell2mat(obj)
%             result = cell2mat(obj.C);
%         end
        
        % todo to improve, for clarity of display
        function [] = disp(obj)
            disp(obj.sm) % for now the function simply prints the underlying object
        end
        
        function [result] = isempty(obj)
            result = isempty(obj.sm);
        end

        function [result] = as_symmatrix(obj)
            % creates symmatrix

            % input validation
            assert(~isempty(obj), "Empty SymbolicBlockMatrix not allowed.")
            % do type conversion
            result = obj.sm;
        end
        
        % Operations
        %%%% DOES NOT WORK CURRENTLY %%%%
%         function [result] = rmult_col_by(obj, j, M)
%             % Right-multiply j-th (block)column of a BlockMatrix by matrix 
%             % Input:
%             %   i: positive integer
%             %   M: matrix (plain)
%             %
%             % Output:
%             %   result: obj but with col i right-multiplied by M
%         
%             %%% Input validation - to be implemented
% 
%             %%% do function
%             obj.C(:,j) = cellfun(@(X) X * M, obj.C(:,j), 'UniformOutput', false);
%             result = obj;
% 
%         end
% 
%         function [result] = lmult_row_by(obj, i, M)
%             % Left-multiply i-th (block)row of a BlockMatrix by matrix 
%             % Input:
%             %   i: positive integer
%             %   M: matrix (plain)
%             %
%             % Output:
%             %   result: obj but with row j left-multiplied by M
%         
%             %%% Input validation - to be implemented
% 
%             %%% do function
% %             obj.C(i,:) = cellfun(@(X) M * BlockMatrix({X}), obj.C(i,:),
% %             'UniformOutput', false); %does not work for some types reason
%             
%             ncol = obj.n_blkcol;
%             for j=1:ncol
%                 obj.C{i,j} = M * BlockMatrix({obj.C{i,j}});
%             end
%             result = obj;
%             
%         end
%         %%%% END OF: DOES NOT WORK CURRENTLY %%%%
%         function [result] = BMblkdiag(obj, BM2)
%             % blkdiag for two BlockMatrix objects
%             % Inputs BlockMatrix objects
%             % Outputs BlockMatrix object
%               
%             [to be implemented]
%         end
        
        %
        % todo to refactor from BlockMatrix to SymbolicBlockMatrix for
        % three functions:
        %   (1) as_readable_table_with_names 
        %   and its two variants: 
        %   (2) as_readable_table_with_names_only_cols, 
        %   (3) as_readable_table_with_names_only_rows.
        %
%         function [result] = as_readable_table_with_names_only_cols(obj)
%             % todo:to be implemented
%             % Idea below 
%             % Limitation: names only columns
%             % (implementation sketched for matrix that has 3 columns partitioned as (2,1)
%             % The actual implementation will have to get indices of
%             % partition
% 
%             ncol = obj.n_blkcol(); % get number of columns
%             blk_ncol(ncol) = 0; % allocate ncol entries vector 
%             
%             % get indices of partition into blocks
%             for i=1:ncol
%                 blk = obj.get_block(1,i);
%                 ncol_of_blk = size(blk, 2);
%                 blk_ncol(i) = ncol_of_blk;
%             end
%             blk_lastcol_ix = cumsum(blk_ncol); % blk_lastcol_ix(i) = index of last column of block i
%             
%             % build table with names of clusters of columns
%             % flat whole cell
%             flat_obj = cell2mat(obj);
%             % hconcat clusters of columns
%             % first columns
%             my_table = table();
%             my_table = addvars(my_table, flat_obj(:,1:blk_lastcol_ix(1)) ...
%                 ,'NewVariableNames','in_space_1');
%             % the remaining columns, if there are any
%             if ncol>1
%                 for i=2:ncol
%                     % hconcat next cluster of columns 
%                     my_table = addvars(my_table, flat_obj(:,(blk_lastcol_ix(i-1)+1):blk_lastcol_ix(i)) ...
%                     ,'NewVariableNames','in_space_' + string(i));
%                 end
%             end
%             result = my_table;
%         end %function
% 
%         
%         function result = as_readable_table_with_names(obj)
%             % Names cols and rows of a BlockMatrix.
%             % Limitations:
%             %   row name is displayed not that nicely
%             %   currently names cannot be controlled (to be implemented)
%             
%             %%% name cols
%             my_table = obj.as_readable_table_with_names_only_cols();
%             
%             %%% name rows
%             %
%             nrow = obj.n_blkrow(); % get number of rows
%             blk_nrow(nrow) = 0; % allocate nrow entries vector  
%             % get indices of partition into blocks
%             for i=1:nrow
%                 blk = obj.get_block(i,1); % use the block from the first column - any block would be ok but the first is ensured to exist
%                 nrow_of_blk = size(blk, 1);
%                 blk_nrow(i) = nrow_of_blk;
%             end
% %             blk_lastrow_ix = cumsum(blk_nrow); % blk_lastrow_ix(i) =
% %             index of last row of block i -- NOT USED AT THE MOMENT
%             
%             % do naming
%             my_rownames = strings(size(my_table, 1),1); % allocate vector for row names
%             curr_row_ix = 1; % index of currently renamed row
%             for i=1:nrow
%                 for j=1:blk_nrow(i)
%                     % name only first row of a block
%                     if j==1
%                         my_rownames(curr_row_ix) = "out_space_" + string(i);
%                     else
%                         my_rownames(curr_row_ix) = ".";
%                     end
%                     curr_row_ix = curr_row_ix + 1;
%                 end
%             end
%             my_table = addvars(my_table, my_rownames ...
%                 , 'Before','in_space_1' ...
%                 ,'NewVariableNames','OutSpaceName');
%             
%             % return result
%             result = my_table;
% 
%         end
    end
end