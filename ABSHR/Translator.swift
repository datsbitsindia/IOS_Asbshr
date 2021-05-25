//
//  Translator.swift
//  ABSHR
//
//  Created by iMac on 31/12/20.
//  Copyright © 2020 skyinfos. All rights reserved.
//

import Foundation
import MLKitTranslate
final class TranslatorManager{
// public static let shared = TranslatorManager()
    
    public func downloadModel(){

        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .arabic)
        
        let englishArabicTranslator = Translator.translator(options: options)
        
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: true,
            allowsBackgroundDownloading: true
        )
        englishArabicTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            self.translateText(text: "Home") { (str) in
                print("Home".localized())
                print(str)
            }
            print("Arabic Model downloaded")
            // Model downloaded successfully. Okay to start translating.
        }
    }
    public func downloadArabicModel(){
        let frModel = TranslateRemoteModel.translateRemoteModel(language: .arabic)

        // Keep a reference to the download progress so you can check that the model
        // is available before you use it.
       let progress = ModelManager.modelManager().download(
            frModel,
            conditions: ModelDownloadConditions(
                allowsCellularAccess: true,
                allowsBackgroundDownloading: true
            )
        )
        print(progress)
    }
    public func translateText(text:String,Complition:@escaping(String) -> Void){
        if getCurrentLang() == "ar-SA"{
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .arabic)
        let englishArabicTranslator = Translator.translator(options: options)
        englishArabicTranslator.translate(text) { translatedText, error in
            guard error == nil, let translatedText = translatedText else {
                print(error?.localizedDescription)
                Complition(text)
                return }
            Complition(translatedText)
            // Translation succeeded.
        }
        }else {
            Complition(text)
        }
    }
}
