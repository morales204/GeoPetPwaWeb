<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class FirebaseAuth
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next)
    {
        if (!session()->has('firebase_uid')) {
            return redirect()->route('login')->withErrors(['auth' => 'Debes iniciar sesión.']);
        }

        return $next($request);
    }

}
