conexion = RunService.RenderStepped:Connect(function(dt)
    if not activo or not personaje.Parent or not clon or not clon.Parent then
        return
    end

    local raizActual = personaje:FindFirstChild("HumanoidRootPart")
    if not raizActual then return end

    tiempo += dt

    -- Tiempo entre cada teletransporte
    local intervalo = 0.15

    if tiempo >= intervalo then
        tiempo -= intervalo

        -- Posiciones alrededor del jugador
        local posiciones = {
            Vector3.new(distancia, 5, 0),
            Vector3.new(-distancia, 5, 0),
            Vector3.new(0, 5, distancia),
            Vector3.new(0, 5, -distancia),
            Vector3.new(distancia * 0.7, 10, distancia * 0.7),
            Vector3.new(-distancia * 0.7, 10, -distancia * 0.7),
            Vector3.new(distancia * 0.7, 15, -distancia * 0.7),
            Vector3.new(-distancia * 0.7, 15, distancia * 0.7)
        }

        -- Elige una posición aleatoria
        local desplazamiento = posiciones[math.random(1, #posiciones)]
        local posicion = raizActual.Position + desplazamiento

        -- Teletransporta el clon sin hacerlo girar
        clon:PivotTo(CFrame.new(posicion))
    end
end