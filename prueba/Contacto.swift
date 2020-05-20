//
//  Contacto.swift
//  prueba
//
//  Created by David on 08/05/20.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

class Contacto{
    var idContacto: String
    var nombreContacto: String
    var celularContacto: String
    var telefonoContacto: String
    var correoUsr: String
    var correoContacto: String
    
    init(idContacto: String, nombreContacto: String, celularContacto: String, telefonoContacto: String,correoUsr: String, correoContacto: String) {
        self.idContacto = idContacto
        self.nombreContacto = nombreContacto
        self.celularContacto = celularContacto
        self.telefonoContacto = telefonoContacto
        self.correoUsr = correoUsr
        self.correoContacto = correoContacto
    }
}
