function [ Cb ] = squrMap( A, B, Ca )

[Oa(1), Oa(2)] = polyxpoly([A(1,1) A(3,1)],[A(1,2) A(3,2)],[A(2,1) A(4,1)],[A(2,2) A(4,2)]);
Oa = Oa';
[Ob(1), Ob(2)] = polyxpoly([B(1,1) B(3,1)],[B(1,2) B(3,2)],[B(2,1) B(4,1)],[B(2,2) B(4,2)]);
Ob = Ob';
Xa = (A(1,:)'-Oa);
Ya = (A(2,:)'-Oa);
Xb = (B(1,:)'-Ob);
Yb = (B(2,:)'-Ob);
Cb = zeros(size(Ca,1),2);
for i = 1 : size(Ca,1)
    OCa = Ca(i,:)'-Oa;
    OCb = [Xb Yb]*([Xa Ya]\OCa);
    Cb(i,:) = (OCb+Ob)';
end

end

