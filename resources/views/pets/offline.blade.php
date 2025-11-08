<x-app-layout>
    <x-slot name="header">
        <h2>Mascotas Extraviadas (Offline)</h2>
    </x-slot>

    <div class="container" style="max-width: 1200px; margin: auto; padding: 20px;">
        <h1 style="text-align: center; color: #333;">🐾 Mascotas Extraviadas</h1>

        <div id="mascotasContainer" style="display: flex; flex-wrap: wrap; gap: 20px; justify-content: center;">
            <!-- Aquí se insertarán las mascotas desde localStorage -->
        </div>

        <p id="noDataMsg" style="text-align: center; margin-top: 50px; color: #777; display: none;">
            No hay mascotas guardadas offline 🐶🐱
        </p>
    </div>
</x-app-layout>

<script>
    // Leer los datos guardados en localStorage
    const data = JSON.parse(localStorage.getItem('ultimasMascotas') || '[]');
    const container = document.getElementById('mascotasContainer');
    const noDataMsg = document.getElementById('noDataMsg');

    if(data.length > 0){
        data.forEach(pet => {
            let imageUrl = null;
            if(pet.fotosMascota?.arrayValue?.values?.length > 0){
                const firstPhoto = pet.fotosMascota.arrayValue.values[0].mapValue.fields;
                if(firstPhoto?.uploadedUrl?.stringValue){
                    imageUrl = firstPhoto.uploadedUrl.stringValue;
                }
            }

            const card = document.createElement('div');
            card.style = "width: 300px; border: 1px solid #ccc; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 8px rgba(0,0,0,0.1); padding: 15px; text-align: center;";

            card.innerHTML = `
                <img src="${imageUrl ?? 'https://cdn-icons-png.flaticon.com/512/616/616408.png'}"
                     style="width:100%; height:200px; object-fit: cover; background:#f4f4f4;">
                <h3 style="margin: 10px 0; color:#333;">${pet.nombre?.stringValue ?? 'Sin nombre'}</h3>
                <p style="margin: 5px 0; color:#666;"><strong>Tipo:</strong> ${pet.tipo?.stringValue ?? 'Desconocido'}</p>
                <p style="margin: 5px 0; color:#666;"><strong>Raza:</strong> ${pet.raza?.stringValue ?? 'Desconocida'}</p>
            `;
            container.appendChild(card);
        });
    } else {
        noDataMsg.style.display = 'block';
    }
</script>
