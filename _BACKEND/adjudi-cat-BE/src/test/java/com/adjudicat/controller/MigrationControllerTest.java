package com.adjudicat.controller;

import com.adjudicat.configuration.BaseTest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebAppConfiguration
@AutoConfigureMockMvc
@Sql({
        "/db/sql/instanciar_tablas.sql",
        "/db/sql/llenar_datos.sql"
})
public class MigrationControllerTest extends BaseTest {

    @Autowired
    private MockMvc mockMvc;

    private static final String BASE = "/api/v1/adj/migration";
    private static final String EXECUTE = BASE + "/execute";

    @Test
    public void migration_ok() throws Exception {
        this.mockMvc.perform(get(EXECUTE)
                .contentType(MediaType.APPLICATION_JSON_VALUE)
        )
                .andExpect(status().isOk());
    }
}
