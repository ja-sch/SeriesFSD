classdef factorization_2f_pm
    % DEPRECATED.
    % Factorization of a matrix with two factors using plain matrices 
    % (three bases to be chosen - initial, middle, and final).
    %   [Detailed explanation goes here]

    properties
        node_init_basis
        mapping_first_core_matrix
        node_middle_basis
        mapping_second_core_matrix
        node_final_basis
    end

    methods
        %% construct
        function obj = factorization_2f_pm(A, B)
            %UNTITLED4 Creates a factorization with canonical bases.
            %   Detailed explanation goes here 
            % validate input: check if A, B can be multiplied (i.e. A*B is
            % well-defined)
            sizeA = size(A);
            sizeB = size(B);
            assert (sizeB(1) == sizeA(2), "The sizes of matrices A and B do not match -- multiplication" + ...
    "A * B is not well-defined.")
            obj.mapping_first_core_matrix = A;
            obj.mapping_second_core_matrix = B;
%             create indentity matrices of appropriate size
            obj.node_init_basis = eye(sizeA(1));
            obj.node_middle_basis = eye(sizeB(1)); % is equivalent to ones(sizeA(2))
            obj.node_final_basis = eye(sizeB(2));
        end
        
        %% Acters and Setters %%
        % Group action functions (acters)
        % (`Right multiplication' is consistent with acting by UAV')
        % The below functions act on bases with input matrices

        % Initial basis
        function obj = act_init_basis(obj, V)
            % alias for function rmul_init_basis
            %
            obj = rmul_init_basis(obj, V);
        end
        function obj = rmul_init_basis(obj, V)
            % rmul_init_basis: right multipliies init basis matrix 
            % and modifies incident mappings cores accordingly 
            % (in this case, it changes the core of left mapping)
            %
            % Input: 
            %   basis: matrix. Columns are vectors.
            %
            %
            
            %% validate input
            tol = 1e-15 % tolerance (chosen manually)
            %%%% square
            assert(size(V, 1) == size(V, 2), "Input matrix is not square")
            %%%% orthogonality
            tested_value_orth = max(max(abs(V * V' - eye(size(V, 1)))));
            condition_orth = tested_value_orth < tol;
            assert(condition_orth, "Input matrix not orthogonal (it is square though)")
            %%%% dimension
            assert(size(V, 1) == size(obj.node_init_basis, 1)...
                , "Input matrix has wrong dimension (it is square and orthogonal though)");

            %% do function
            % adjust bases in all incident components
            % right neighbors
            obj.mapping_first_core_matrix = V' * obj.mapping_first_core_matrix;
            % left neighbors
            % [there are none]
            
            % adjust basis
            obj.node_init_basis = obj.node_init_basis * V;
        end
        
        % setter for init basis, might get out of use
        function obj = set_init_basis(obj, basis)
            % set init basis: sets init basis and modifies incident mappings cores
            % accordingly (it changes the core of left mapping)
            %
            % Input: 
            %   basis - matrix. Columns are vectors.
            %
            %
            
            %%% validate input
            tol = 1e-15 % tolerance (chosen manually)
            % orthogonality
            sizebasis = size(basis);
            assert(sizebasis(1) == sizebasis(2), "Input matrix is not square")
            tested_value_orth = max(max(abs(basis * basis' - eye(sizebasis(1)))));
            condition_orth = tested_value_orth < tol;
            assert(condition_orth, "Input matrix not orthogonal (it is square though)")
            
            %%%% dimensions (are they matching)
            A = obj.mapping_first_core_matrix;
            sizeA = size(A);
            % right neighbors
            assert(sizebasis(2) == sizeA(1)...
                , "Dimensions of input matrix and its intended neighbors do not match " + ...
                "(neighbors = first core matrix (right neighbor))");
            % left neighbors
            % [there are none]


            %%% do function
            % adjust bases in all incident components
            obj.mapping_first_core_matrix = basis' * obj.node_init_basis * obj.mapping_first_core_matrix;
            
            % set basis
            obj.node_init_basis = basis;
        end
        %% get
        function result = product(obj)
            %METHOD1 Simply multiply our factorization -- Return product of all factors
            %   Detailed explanation goes here
            result =    (...
                    obj.node_init_basis * ... 
                    obj.mapping_first_core_matrix * ...
                    obj.mapping_second_core_matrix * ...
                    obj.node_final_basis);
        end
        
        
        %%% mappings
        function result = mapping_first(obj)
            result = obj.node_init_basis * obj.mapping_first_core_matrix * obj.node_middle_basis';
        end

        function result = mapping_second(obj)
            result = obj.node_middle_basis * obj.mapping_second_core_matrix * obj.node_final_basis';
        end

        %% printing
        %todo my_print(obj) % for printing use cells (to be implemented)

        %% aux
        function obj = reset_bases(obj)
            % Resets all bases to standard bases.
            %
            %
            % retrieve original mappings (could be any, we do it with our previously defined function)
            A = mapping_first(obj);
            B = mapping_second(obj);
            % get sizes
            sizeA = size(A);
            sizeB = size(B);
%             set bases to indentity matrices of appropriate size
            obj.node_init_basis = eye(sizeA(1));
            obj.node_middle_basis = eye(sizeB(1)); % is equivalent to ones(sizeA(2))
            obj.node_final_basis = eye(sizeB(2));
        end
    end
end