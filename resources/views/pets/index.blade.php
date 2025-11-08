<x-app-layout>
    <x-slot name="header">
        <h2>Mascotas Extraviadas</h2>
    </x-slot>

    <div class="container" style="max-width: 1200px; margin: auto; padding: 20px;">
        <h1 style="text-align: center; color: #333;">🐾 Mascotas Extraviadas</h1>

        @if(!empty($data))
            <div style="display: flex; flex-wrap: wrap; gap: 20px; justify-content: center;">
                @foreach ($data as $pet)
                    <div style="width: 300px; border: 1px solid #ccc; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 8px rgba(0,0,0,0.1); transition: transform 0.3s;">
                         @php
                                $imageUrl = null;
                                if (!empty($pet['fotosMascota']['arrayValue']['values'])) {
                                    $firstPhoto = $pet['fotosMascota']['arrayValue']['values'][0]['mapValue']['fields'] ?? null;
                                    if (!empty($firstPhoto['uploadedUrl']['stringValue'])) {
                                        $imageUrl = $firstPhoto['uploadedUrl']['stringValue'];
                                    }
                                }
                            @endphp

                            @if ($imageUrl)
                                <img src="{{ $imageUrl }}" alt="Mascota"
                                     style="width: 100%; height: 200px; object-fit: cover;">
                            @else
                                <img src="https://cdn-icons-png.flaticon.com/512/616/616408.png" alt="Sin imagen"
                                     style="width: 100%; height: 200px; object-fit: cover; background: #f4f4f4;">
                            @endif

                        <div style="padding: 15px; text-align: center;">
                            <h3 style="margin: 10px 0; color: #333;">{{ $pet['nombre']['stringValue'] ?? 'Sin nombre' }}</h3>
                            <p style="margin: 5px 0; color: #666;"><strong>Tipo:</strong> {{ $pet['tipo']['stringValue'] ?? 'Desconocido' }}</p>
                            <p style="margin: 5px 0; color: #666;"><strong>Raza:</strong> {{ $pet['raza']['stringValue'] ?? 'Desconocida' }}</p>
                        </div>
                    </div>
                @endforeach
            </div>
        @else
            <p style="text-align: center; margin-top: 50px; color: #777;">No hay mascotas extraviadas 🐶🐱</p>
        @endif
    </div>
</x-app-layout>

<script>
    // Guardar en localStorage los datos recibidos para offline
    localStorage.setItem('ultimasMascotas', JSON.stringify(@json($data)));
</script>
