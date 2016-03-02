Prefix ex: <http://ex.org/>
Prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
Prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
Prefix xsd: <http://www.w3.org/2001/XMLSchema#>
Prefix chado: <http://biohackathon.org/chado/>

CREATE VIEW feature AS
    CONSTRUCT {
        ?f a chado:feature;
           rdfs:label ?l ;
           a ?cvterm
        .
    }
    WITH
        ?f = uri( chado:feature, ?feature_id )
        ?l = plainLiteral( ?name )
        ?cvterm = uri( chado:cvterm, ?type_id )
    FROM
        feature


CREATE VIEW featureloc AS
    CONSTRUCT {
        ?floc a chado:featureloc;
           chado:fmin ?fmin ;
           chado:fmax ?fmax ;
           chado:source_feature ?srcfeature ;
           chado:strand ?strand
        .
        ?feature chado:located_at ?floc
        .
    }
    WITH
        ?strand = plainLiteral( ?strand )
        ?srcfeature = uri( chado:feature, ?srcfeature_id )
        ?feature = uri( chado:feature, ?feature_id )
        ?floc = uri( chado:featureloc, ?featureloc_id )
        ?fmin = plainLiteral( ?fmin )
        ?fmax = plainLiteral( ?fmax )
    FROM
        featureloc

CREATE VIEW cvterm AS
       CONSTRUCT {
          ?cvterm a chado:cvterm ;
             rdfs:label ?name ;
             chado:is_obsolete ?obsolete ;
             chado:from_cv ?cv
        }
        WITH
           ?cvterm = uri( chado:cvterm, ?cvterm_id )
           ?name = plainLiteral( ?name )
           ?obsolete = plainLiteral( ?is_obsolete )
           ?cv = uri( chado:cv, ?cv_id )
        FROM
           cvterm

CREATE VIEW cv AS
        CONSTRUCT {
           ?cv a chado:cv ;
              rdfs:label ?name
           .
        }
        WITH
           ?name = plainLiteral( ?name )
           ?cv = uri( chado:cv, ?cv_id )
        FROM
          cv


CREATE VIEW feature_relationship AS
       CONSTRUCT {
           ?relationship rdf:subject ?subject ;
               rdf:predicate ?type ;
               rdf:object ?object
           .
       }
       WITH
           ?subject = uri( chado:feature, ?subject_id )
           ?object = uri( chado:feature, ?object_id )
           ?type = uri( chado:cvterm, ?type_id )
           ?relationship = uri( chado:feature_relationship, ?feature_relationship_id )
       FROM
           feature_relationship
