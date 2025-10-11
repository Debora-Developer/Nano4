//
//  CameraViewController.swift
//  test55
//
//  Created by Débora Costa on 08/10/25.
//


import SwiftUI
import AVFoundation

class CameraViewController: UIViewController {
    // AVCaptureSession: Gerencia o fluxo de dados do dispositivo de captura (câmera/microfone).
    // É o "cérebro" da sessão de câmera.
    private var captureSession: AVCaptureSession!
    
    // AVCapturePhotoOutput: Captura fotos da sessão de captura.
    // Ele é responsável por tirar a foto propriamente dita.
    private var photoOutput: AVCapturePhotoOutput!
    
    // AVCaptureVideoPreviewLayer: Exibe o que a câmera está "vendo" na tela.
    // É a camada de vídeo que mostra a pré-visualização ao usuário.
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    // Uma referência ao Coordinator da CameraView para lidar com os delegates de captura de foto.
    // O Coordinator é o elo entre esta classe (UIViewController) e a View SwiftUI.
    var coordinator: CameraView.Coordinator?

    // Método chamado quando a view é carregada na memória.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Define o fundo da view como preto antes mesmo da pré-visualização da câmera aparecer.
        view.backgroundColor = .black
        // Inicia o processo de verificação de permissões e configuração da câmera.
        checkCameraPermissionsAndSetup()
    }
    
    // Método chamado quando o layout das subviews precisa ser ajustado (por exemplo, em rotação).
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Garante que a camada de pré-visualização da câmera preencha todo o espaço da view.
        previewLayer?.frame = view.bounds
    }

    // Verifica o status da permissão da câmera e solicita, se necessário.
    private func checkCameraPermissionsAndSetup() {
        // Usa um switch para lidar com os diferentes estados de autorização para a câmera.
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Se já autorizado, configura a sessão de captura imediatamente.
            setupCaptureSession()
        case .notDetermined:
            // Se o usuário ainda não decidiu, solicita a permissão.
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                // O bloco é executado após o usuário responder à solicitação.
                if granted {
                    // Se a permissão for concedida, configura a sessão na thread principal.
                    DispatchQueue.main.async {
                        self?.setupCaptureSession()
                    }
                }
            }
        case .denied, .restricted:
            // Se a permissão for negada ou restrita, idealmente, um alerta deveria ser mostrado aqui.
            // Por enquanto, apenas ignora, mas em uma app real, o usuário precisaria de feedback.
            break
        @unknown default:
            // Lida com qualquer caso futuro desconhecido para evitar falhas.
            break
        }
    }

    // Configura a sessão de captura (AVCaptureSession) com a câmera traseira e saída de foto.
    private func setupCaptureSession() {
        // Inicializa a sessão de captura.
        captureSession = AVCaptureSession()
        // Define a predefinição da sessão para captura de fotos de alta qualidade.
        captureSession.sessionPreset = .photo

        // Tenta obter a câmera traseira padrão do dispositivo.
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Não foi possível encontrar a câmera traseira.")
            return // Se não encontrar, sai da função.
        }

        do {
            // Cria uma entrada para a câmera traseira.
            let input = try AVCaptureDeviceInput(device: backCamera)
            // Inicializa a saída para fotos.
            photoOutput = AVCapturePhotoOutput()

            // Verifica se a sessão pode adicionar a entrada e a saída.
            if captureSession.canAddInput(input) && captureSession.canAddOutput(photoOutput) {
                // Adiciona a entrada da câmera à sessão.
                captureSession.addInput(input)
                // Adiciona a saída de fotos à sessão.
                captureSession.addOutput(photoOutput)
                // Configura a camada de pré-visualização para exibir o vídeo.
                setupPreviewLayer()
            }
        } catch {
            // Em caso de erro ao configurar a câmera (ex: acesso negado), imprime a descrição.
            print("Erro ao configurar a câmera: \(error.localizedDescription)")
        }
    }

    // Configura e exibe a camada de pré-visualização de vídeo.
    private func setupPreviewLayer() {
        // Cria uma camada de pré-visualização com a sessão de captura.
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // Define como o vídeo se ajusta à camada (preencher o espaço, mantendo a proporção).
        previewLayer.videoGravity = .resizeAspectFill
        
        // Trata a orientação do vídeo, usando a nova API para iOS 17+ e a antiga para versões anteriores.
        if #available(iOS 17.0, *) {
            // Para iOS 17 e superior, usa videoRotationAngle.
            // .portrait (orientação retrato) corresponde a uma rotação de 90 graus no sentido horário.
            previewLayer.connection?.videoRotationAngle = 90
        } else {
            // Para versões anteriores a iOS 17, usa videoOrientation (que está depreciado).
            previewLayer.connection?.videoOrientation = .portrait
        }
        // Adiciona a camada de pré-visualização como uma subcamada da view do controlador.
        view.layer.addSublayer(previewLayer)
        
        // Inicia a sessão de captura em uma thread de fundo para não bloquear a UI.
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning() // Inicia o fluxo da câmera.
            // Uma vez que a sessão está rodando, atualiza o frame da pré-visualização na thread principal.
            DispatchQueue.main.async {
                self?.previewLayer.frame = self?.view.bounds ?? .zero
            }
        }
    }

    // Dispara a captura de uma foto.
    func capturePhoto() {
        // Garante que o coordinator esteja configurado para receber o resultado da foto.
        guard let coordinator = self.coordinator else {
            print("Coordinator não configurado para captura de foto.")
            return
        }
        // Cria as configurações para a captura da foto (pode ser personalizado, mas aqui é o padrão).
        let settings = AVCapturePhotoSettings()
        // Pede ao photoOutput para capturar uma foto, usando o coordinator como delegado.
        photoOutput.capturePhoto(with: settings, delegate: coordinator)
    }
}
