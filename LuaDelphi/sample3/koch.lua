function Koch(T, L)
  if (L > 5) then
    Koch(T, L/3) T:L(60)
    Koch(T, L/3) T:R(120)
    Koch(T, L/3) T:L(60)
    Koch(T, L/3)
  else
    T:F(L)
  end
end

T = TTortoise{X=0, Y=0, Angle=0}

Clear()
for I = 0,2 do
  Koch(T, 200)
  T:R(120)
end

T:Free()
