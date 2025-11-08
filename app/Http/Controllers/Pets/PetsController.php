<?php
namespace App\Http\Controllers\Pets;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use App\Http\Controllers\Controller;

use Kreait\Firebase\Database;
use Illuminate\Support\Facades\Http;

class PetsController extends Controller{


    public function index(){
       // Conecta con Firebase usando tu archivo JSON
               $projectId ='petsai-f7484';
        $apiKey = 'AIzaSyB3Wtj_WE-2X91AT1YEZApNDh76wNUGfcw';

        // Nombre de tu colección
        $collection = 'mascotas';

        // URL de la API REST de Firestore
        $url = "https://firestore.googleapis.com/v1/projects/{$projectId}/databases/(default)/documents:runQuery?key={$apiKey}";

                // Cuerpo de la consulta (query)
        $query = [
            "structuredQuery" => [
                "from" => [
                    ["collectionId" => $collection]
                ],
                "where" => [
                    "fieldFilter" => [
                        "field" => ["fieldPath" => "estaPerdida"],
                        "op" => "EQUAL",
                        "value" => ["booleanValue" => true]
                    ]
                ]
            ]
        ];

        // Hacemos la petición HTTP
        $response = Http::post($url, $query);

        if ($response->failed()) {
            return response()->json(['error' => 'No se pudo conectar con Firestore', 'details' => $response->body()], 500);
        }

                $documents = $response->json();

        // Procesar la respuesta para quedarnos solo con los datos de cada documento
        $data = [];
        foreach ($documents as $doc) {
            if (isset($doc['document'])) {
                $data[] = $doc['document']['fields'];
            }
        }


        return view('pets.index', ['data' => $data]);

    }
}