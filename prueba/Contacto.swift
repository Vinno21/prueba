//
//  Contacto.swift
//  prueba
//
//  Created by David on 08/05/20.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

class Contacto{
    var cvcte: String
    var nomCte: String
    var domCte: String
    init(cvCliente: String, nomCliente: String, domCliente: String) {
        self.cvcte = cvCliente
        self.nomCte = nomCliente
        self.domCte = domCliente
    }
}
