package mesopotamia.mesopotamia;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping(value = "/api/v1/mesopotamia")
@CrossOrigin
public class MesopotamiaController {

    @GetMapping
    public ResponseEntity<MesopotamiaDto> getResource() {
        return ResponseEntity.status(HttpStatus.OK).body(new MesopotamiaDto("Mesopotamia resource"));
    }

}
