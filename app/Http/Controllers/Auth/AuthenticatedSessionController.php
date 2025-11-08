<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\View\View;

use Kreait\Firebase\Auth as FirebaseAuth;
use App\Models\User;
use Kreait\Firebase\Factory;


class AuthenticatedSessionController extends Controller
{
    public function create(): View
    {
        return view('auth.login');
    }

    /**
     * Handle an incoming authentication request.
     */
    public function store(Request $request): RedirectResponse
    {
        $request->validate([
            'email' => ['required', 'string', 'email'],
            'password' => ['required'],
        ]);

        $auth = (new Factory)
        ->withServiceAccount(base_path(env('FIREBASE_CREDENTIALS')))
        ->createAuth();

        try {
            $signInResult = $auth->signInWithEmailAndPassword($request->email, $request->password);
            $firebaseUser = $signInResult->firebaseUserId();

            session([
                'firebase_uid' => $firebaseUser,
                'firebase_email' => $request->email,
                'firebase_token' => $signInResult->idToken(),
            ]);

            return redirect()->intended(route('dashboard'));
        } catch (\Throwable $e) {
            return back()->withErrors([
                'email' => 'Credenciales inválidas o usuario no registrado.',
            ]);
        }

    }

    /**
     * Destroy an authenticated session.
     */
    public function destroy(Request $request)
    {
        session()->flush();
        return redirect('/');

    }
}
