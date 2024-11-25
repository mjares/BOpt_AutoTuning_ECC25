function q_r = kronnecker_quat(q, r)
    
    % Kronnecker product between quaternions
    m_tmp = zeros(4, 4);
   
    m_tmp(1, :) = [q(1) -q(2:4)'];
    m_tmp(2:4, 1) = q(2:4);
    m_tmp(2:4, 2:4) = eye(3,3)*q(1) + [0 -q(4) q(3); q(4) 0 -q(2); -q(3) q(2) 0];
    
    q_r = m_tmp*r;
    
end