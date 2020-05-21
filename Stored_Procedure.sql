
####### CREATING TABLES #########

create table disnet_concept
(
    cui  varchar(8)   not null
        primary key,
    name varchar(250) not null
);

create table disnet_document
(
    document_id varchar(30) not null,
    date        date        not null,
    primary key (document_id, date)
);

create table disorder
(
    disorder_id varchar(150)      not null
        primary key,
    name        varchar(150)      not null,
    cui         varchar(8)        null,
    relevant    tinyint default 1 null
);

create table has_disorder
(
    document_id varchar(30)  not null,
    date        date         not null,
    disorder_id varchar(150) not null,
    primary key (document_id, date, disorder_id),
    constraint fk_dis_document_has_disease_document1
        foreign key (document_id, date) references disnet_document (document_id, date)
            on update cascade on delete cascade,
    constraint fk_dis_document_has_disorder_disorder1
        foreign key (disorder_id) references disorder (disorder_id)
);

create index fk_dis_document_has_disorder_disorder1_idx
    on has_disorder (disorder_id);

create index fk_dis_document_has_disorder_document1_idx
    on has_disorder (document_id, date);

create table paper
(
    paper_id       varchar(250) not null comment 'En PubMed es el pmid '
        primary key,
    doi            varchar(255) null,
    alternative_id varchar(255) null comment 'ID inside the source. PubMed=pmcid',
    title          text         not null,
    authors        text         null,
    keywords       text         null,
    free_text      tinyint(1)   null
);

create table document_set
(
    document_id varchar(30)  not null,
    date        date         not null,
    paper_id    varchar(250) not null,
    primary key (document_id, date, paper_id),
    constraint fk_dis_document_has_paper_document1
        foreign key (document_id, date) references disnet_document (document_id, date)
            on update cascade on delete cascade,
    constraint fk_dis_document_has_paper_paper1
        foreign key (paper_id) references paper (paper_id)
            on update cascade on delete cascade
);

create index fk_dis_document_has_paper_document1_idx
    on document_set (document_id, date);

create index fk_dis_document_has_paper_paper1_idx
    on document_set (paper_id);

create table process
(
    process_id varchar(10) not null
        primary key,
    name       varchar(50) not null
);

create table retrieval_method
(
    retrieval_method_id int auto_increment
        primary key,
    name                varchar(150) not null,
    description         varchar(350) null
)
    charset = latin1;

create table section
(
    section_id  varchar(10)  not null
        primary key,
    name        varchar(250) not null,
    description varchar(250) not null
);

create table has_section
(
    document_id varchar(30) not null,
    date        date        not null,
    section_id  varchar(10) not null,
    primary key (document_id, date, section_id),
    constraint fk_dis_document_has_section_document1
        foreign key (document_id, date) references disnet_document (document_id, date)
            on update cascade on delete cascade,
    constraint fk_dis_document_has_section_section1
        foreign key (section_id) references section (section_id)
);

create index fk_dis_document_has_section_document1_idx
    on has_section (document_id, date);

create index fk_dis_document_has_section_section1_idx
    on has_section (section_id);

create table semantic_type
(
    semantic_type varchar(8)  not null
        primary key,
    description   varchar(50) null
);

create table has_semantic_type
(
    cui           varchar(8) not null,
    semantic_type varchar(8) not null,
    primary key (cui, semantic_type),
    constraint fk_symptom_has_semantic_type_semantic_type2
        foreign key (semantic_type) references semantic_type (semantic_type),
    constraint fk_symptom_has_semantic_type_symptom2
        foreign key (cui) references disnet_concept (cui)
            on update cascade on delete cascade
);

create index fk_symptom_has_semantic_type_semantic_type2_idx
    on has_semantic_type (semantic_type);

create index fk_symptom_has_semantic_type_symptom2_idx
    on has_semantic_type (cui);

create table source
(
    source_id varchar(10)  not null
        primary key,
    name      varchar(150) not null
);

create table has_source
(
    document_id varchar(30) not null,
    date        date        not null,
    source_id   varchar(10) not null,
    primary key (document_id, date, source_id),
    constraint fk_dis_document_has_source_document1
        foreign key (document_id, date) references disnet_document (document_id, date)
            on update cascade on delete cascade,
    constraint fk_dis_document_has_source_source1
        foreign key (source_id) references source (source_id)
);

create index fk_dis_document_has_source_document1_idx
    on has_source (document_id, date);

create index fk_dis_document_has_source_source1_idx
    on has_source (source_id);

create table synonym
(
    synonym_id int auto_increment
        primary key,
    name       varchar(150) not null
)
    charset = latin1;

create table disorder_synonym
(
    disorder_id varchar(150) not null,
    synonym_id  int          not null,
    primary key (disorder_id, synonym_id),
    constraint fk_disorder_has_synonym_synonym1
        foreign key (synonym_id) references synonym (synonym_id)
)
    charset = latin1;

create index fk_disorder_has_synonym_disorder1_idx
    on disorder_synonym (disorder_id);

create index fk_disorder_has_synonym_synonym1_idx
    on disorder_synonym (synonym_id);

create table synonym_retrieval_method
(
    synonym_id          int not null,
    retrieval_method_id int not null,
    primary key (synonym_id, retrieval_method_id),
    constraint fk_synonym_has_retrieval_method_retrieval_method1
        foreign key (retrieval_method_id) references retrieval_method (retrieval_method_id),
    constraint fk_synonym_has_retrieval_method_synonym1
        foreign key (synonym_id) references synonym (synonym_id)
)
    charset = latin1;

create index fk_synonym_has_retrieval_method_retrieval_method1_idx
    on synonym_retrieval_method (retrieval_method_id);

create index fk_synonym_has_retrieval_method_synonym1_idx
    on synonym_retrieval_method (synonym_id);

create table text
(
    text_id      varchar(255)                   not null
        primary key,
    content_type enum ('PARA', 'LIST', 'TABLE') not null,
    text         text                           not null comment 'TITLE AND TEXT
'
);

create table has_concept
(
    text_id         varchar(255)  not null,
    cui             varchar(8)    not null,
    validated       tinyint(1)    not null,
    matched_words   varchar(3000) null comment 'words in the text by which the concept was found',
    positional_info varchar(500)  null comment 'positions (number) in the text',
    primary key (text_id, cui),
    constraint fk_text_has_symptom_symptom1
        foreign key (cui) references disnet_concept (cui)
            on update cascade on delete cascade,
    constraint fk_text_has_symptom_text1
        foreign key (text_id) references text (text_id)
            on update cascade on delete cascade
);

create index fk_text_has_symptom_text1_idx
    on has_concept (text_id);

create table has_text
(
    document_id varchar(30)  not null,
    date        date         not null,
    section_id  varchar(10)  not null,
    text_id     varchar(255) not null,
    text_order  int          not null,
    primary key (document_id, date, section_id, text_id),
    constraint fk_has_section_has_text_has_section1
        foreign key (document_id, date, section_id) references has_section (document_id, date, section_id)
            on update cascade on delete cascade,
    constraint fk_has_section_has_text_text1
        foreign key (text_id) references text (text_id)
            on update cascade on delete cascade
);

create index fk_has_section_has_text_has_section1_idx
    on has_text (document_id, date, section_id);

create index fk_has_section_has_text_text1_idx
    on has_text (text_id);

create table tool
(
    tool_id     varchar(10)  not null
        primary key,
    name        varchar(50)  null,
    description varchar(150) null
);

create table configuration
(
    conf_id       varchar(50) not null
        primary key,
    source_id     varchar(10) not null,
    snapshot      date        not null,
    tool_id       varchar(10) not null,
    configuration mediumtext  null,
    constraint configuration_source_fk
        foreign key (source_id) references source (source_id),
    constraint configuration_tool_fk
        foreign key (tool_id) references tool (tool_id)
);

create table parameter
(
    parameter_id varchar(10) not null
        primary key,
    tool_id      varchar(10) not null,
    process_id   varchar(10) not null,
    constraint fk_parameter_has_process_id
        foreign key (process_id) references process (process_id)
            on update cascade on delete cascade,
    constraint fk_parameter_has_tool_id
        foreign key (tool_id) references tool (tool_id)
            on update cascade on delete cascade
);

create table url
(
    url_id varchar(250) collate utf8mb4_unicode_ci not null
        primary key,
    url    varchar(350) collate utf8mb4_unicode_ci not null
)
    charset = utf8mb4;

create table document_url
(
    document_id varchar(30)  not null,
    date        date         not null,
    url_id      varchar(250) not null,
    primary key (document_id, date, url_id),
    constraint fk_dis_document_has_url_document1
        foreign key (document_id, date) references disnet_document (document_id, date)
            on update cascade on delete cascade,
    constraint fk_dis_document_has_url_url1
        foreign key (url_id) references url (url_id)
            on update cascade
);

create index fk_dis_document_has_url_document1_idx
    on document_url (document_id, date);

create index fk_dis_document_has_url_url1_idx
    on document_url (url_id);

create table paper_url
(
    paper_id varchar(250) not null,
    url_id   varchar(250) not null,
    primary key (paper_id, url_id),
    constraint fk_paper_has_url_paper1
        foreign key (paper_id) references paper (paper_id)
            on update cascade on delete cascade,
    constraint fk_paper_has_url_url1
        foreign key (url_id) references url (url_id)
);

create index fk_paper_has_url_paper1_idx
    on paper_url (paper_id);

create table source_url
(
    source_id varchar(10)  not null,
    url_id    varchar(250) not null,
    primary key (source_id, url_id),
    constraint fk_source_has_url_source1
        foreign key (source_id) references source (source_id),
    constraint fk_source_has_url_url1
        foreign key (url_id) references url (url_id)
);

create index fk_source_has_url_source1_idx
    on source_url (source_id);

create table text_url
(
    text_id varchar(255) not null,
    url_id  varchar(250) not null,
    primary key (text_id, url_id),
    constraint fk_text_has_url_text2
        foreign key (text_id) references text (text_id)
            on update cascade on delete cascade,
    constraint fk_text_has_url_url2
        foreign key (url_id) references url (url_id)
);

create index fk_text_has_url_text2_idx
    on text_url (text_id);

create table vocabulary
(
    vocabulary_id int          not null
        primary key,
    name          varchar(100) not null
)
    charset = latin1;

create table code
(
    code          varchar(150) not null,
    vocabulary_id int          not null,
    primary key (code, vocabulary_id),
    constraint fk_code_reference1
        foreign key (vocabulary_id) references vocabulary (vocabulary_id)
);

create index fk_code_resource1_idx
    on code (vocabulary_id);

create table code_retrieval_method
(
    code                varchar(150) not null,
    vocabulary_id       int          not null,
    retrieval_method_id int          not null,
    primary key (code, vocabulary_id, retrieval_method_id),
    constraint fk_code_has_retrieval_method_code1
        foreign key (code, vocabulary_id) references code (code, vocabulary_id),
    constraint fk_code_has_retrieval_method_retrieval_method1
        foreign key (retrieval_method_id) references retrieval_method (retrieval_method_id)
);

create index fk_code_has_retrieval_method_code1_idx
    on code_retrieval_method (code, vocabulary_id);

create index fk_code_has_retrieval_method_retrieval_method1_idx
    on code_retrieval_method (retrieval_method_id);

create table code_url
(
    code          varchar(150) not null,
    vocabulary_id int          not null,
    url_id        varchar(250) not null,
    primary key (code, vocabulary_id, url_id),
    constraint fk_code_has_url_code1
        foreign key (code, vocabulary_id) references code (code, vocabulary_id),
    constraint fk_code_has_url_url1
        foreign key (url_id) references url (url_id)
);

create index fk_code_has_url_code1_idx
    on code_url (code, vocabulary_id);

create index fk_code_has_url_url1_idx
    on code_url (url_id);

create table has_code
(
    document_id   varchar(30)  not null,
    date          date         not null,
    code          varchar(150) not null,
    vocabulary_id int          not null,
    primary key (document_id, date, code, vocabulary_id),
    constraint fk_dis_document_has_code_code1
        foreign key (code, vocabulary_id) references code (code, vocabulary_id)
            on update cascade on delete cascade,
    constraint fk_dis_document_has_code_document1
        foreign key (document_id, date) references disnet_document (document_id, date)
            on update cascade on delete cascade
);

create index fk_dis_document_has_code_code1_idx
    on has_code (code, vocabulary_id);

create index fk_dis_document_has_code_document1_idx
    on has_code (document_id, date);

create table synonym_code
(
    synonym_id    int          not null,
    code          varchar(150) not null,
    vocabulary_id int          not null,
    primary key (synonym_id, code, vocabulary_id),
    constraint fk_synonym_has_code_code1
        foreign key (code, vocabulary_id) references code (code, vocabulary_id),
    constraint fk_synonym_has_code_synonym1
        foreign key (synonym_id) references synonym (synonym_id)
);

create index fk_synonym_has_code_code1_idx
    on synonym_code (code, vocabulary_id);

create index fk_synonym_has_code_synonym1_idx
    on synonym_code (synonym_id);

create table term
(
    term_id       int auto_increment
        primary key,
    vocabulary_id int          null,
    name          varchar(350) not null,
    constraint fk_term_resource1
        foreign key (vocabulary_id) references vocabulary (vocabulary_id)
)
    charset = latin1;

create table paper_term
(
    paper_id varchar(250) not null,
    term_id  int          not null,
    primary key (paper_id, term_id),
    constraint fk_paper_has_term_paper1
        foreign key (paper_id) references paper (paper_id)
            on update cascade on delete cascade,
    constraint fk_paper_has_term_term1
        foreign key (term_id) references term (term_id)
);

create index fk_paper_has_term_paper1_idx
    on paper_term (paper_id);

create index fk_term_vocabulary1_idx
    on term (vocabulary_id);

create table term_type
(
    term_type_id varchar(250) not null,
    name         varchar(200) not null,
    term_id      int          not null,
    primary key (term_type_id, term_id),
    constraint fk_term_type_has_term_id
        foreign key (term_id) references term (term_id)
            on update cascade on delete cascade
);


##### INSERTING DATA INTO THE TABLES ###########


    INSERT INTO modified_edsssdb.has_disorder(document_id, date, disorder_id)
    SELECT hd.document_id, hd.date, hd.disease_id
    from edsssdb.has_disease hd;

    INSERT INTO modified_edsssdb.paper(paper_id, doi, alternative_id, title, authors, keywords, free_text)
    SELECT p.paper_id, p.doi, p.alternative_id, p.title, p.authors, p.keywords, p.free_text
    from edsssdb.paper p;

    INSERT INTO modified_edsssdb.document_set (document_id, date, paper_id)
    SELECT d.document_id, d.date, d.paper_id
    from edsssdb.document_set d;

    INSERT INTO modified_edsssdb.code(code, reference_id)
    SELECT c.code, c.reference_id
    from edsssdb.code c;

    INSERT INTO modified_edsssdb.has_code(document_id, date, code, reference_id)
    SELECT hc.document_id, hc.date, hc.code, hc.reference_id
    from edsssdb.has_code hc;

    INSERT INTO modified_edsssdb.retrieval_method(retrieval_method_id, name, description)
    SELECT rm.retrieval_method_id, rm.name, rm.description
    from edsssdb.retrieval_method rm;

    INSERT INTO modified_edsssdb.code_retrieval_method(code, reference_id, retrieval_method_id)
    SELECT cr.code, cr.reference_id, cr.retrieval_method_id
    from edsssdb.code_retrieval_method cr;

    INSERT INTO modified_edsssdb.section(section_id, name, description)
    SELECT s.section_id, s.name, s.description
    from edsssdb.section s;

    INSERT INTO modified_edsssdb.has_section(document_id, date, section_id)
    SELECT hs.document_id, hs.date, hs.section_id
    from edsssdb.has_section hs;

    INSERT INTO modified_edsssdb.semantic_types(semantic_type, description)
    SELECT st.semantic_type, st.description
    from edsssdb.semantic_type st;

    INSERT INTO modified_edsssdb.source(source_id, name)
    SELECT so.source_id, so.name
    from edsssdb.source so;

    INSERT INTO modified_edsssdb.has_source(document_id, date, source_id)
    SELECT hso.document_id, hso.date, hso.source_id
    from edsssdb.has_source hso;

    INSERT INTO modified_edsssdb.symptom(cui, name)
    SELECT sy.cui, sy.name
    from edsssdb.symtpom sy;

    INSERT INTO modified_edsssdb.has_semantic_type(cui, semantic_type)
    SELECT hst.cui, hst.semantic_type
    from edsssdb.has_semantic_type hst;

    INSERT INTO modified_edsssdb.synonym(synonym_id, name)
    SELECT syn.synonym_id, syn.name
    from edsssdb.synonym syn;

    INSERT INTO modified_edsssdb.disorder_synonym(disorder_id, synonym_id)
    SELECT ds.disease_id, ds.synonym_id
    from edsssdb.disease_synonym ds;

    INSERT INTO modified_edsssdb.synonym_code(synonym_id, code, reference_id)
    SELECT sc.synonym_id, sc.code, sc.reference_id
    from edsssdb.synonym_code sc;

    INSERT INTO modified_edsssdb.synonym_retrieval_method(synonym_id, retrieval_method_id)
    SELECT sym.synonym_id, sym.retrieval_method_id
    from edsssdb.synonym_retrieval_method sym;

    INSERT INTO modified_edsssdb.term(term_id, reference_id, name)
    SELECT t.term_id, t.reference_id, t.name
    from edsssdb.term t;

    INSERT INTO modified_edsssdb.paper_term(paper_id, term_id)
    SELECT pt.paper_id, pt.term_id
    from edsssdb.paper_term pt;

    INSERT INTO modified_edsssdb.text(text_id, content_type, text)
    SELECT te.text_id, te.content_type, te.text
    from edsssdb.text te;


    INSERT INTO modified_edsssdb.has_symptom(text_id, cui, validated, matched_words, positional_info)
    SELECT hsy.text_id, hsy.cui, hsy.validated, hsy.matched_words, hsy.positional_info
    from edsssdb.has_symptom hsy;

    INSERT INTO modified_edsssdb.has_text(document_id, date, section_id, text_id, text_order)
    SELECT ht.document_id, ht.date, ht.section_id, ht.text_id, ht.text_order
    from edsssdb.has_text ht;

    INSERT INTO modified_edsssdb.configuration(conf_id, source_id, snapshot, tool_id, parameters)
    SELECT co.conf_id, co.source_id, co.snapshot, co.tool_id, co.parameters
    from edsssdb.configuration co;

    INSERT INTO modified_edsssdb.code_url(code, reference_id, url_id)
    SELECT cu.code, cu.reference_id, cu.url_id
    from edsssdb.code_url cu;

    INSERT INTO modified_edsssdb.document_url(document_id, date, url_id)
    SELECT du.document_id, du.date, du.url_id
    from edsssdb.document_url du;

    INSERT INTO modified_edsssdb.paper_url(paper_id, url_id)
    SELECT pu.paper_id, pu.url_id
    from edsssdb.paper_url pu;

    INSERT INTO modified_edsssdb.source_url(source_id, url_id)
    SELECT su.source_id, su.url_id
    from edsssdb.source_url su;

    INSERT INTO modified_edsssdb.text_url(text_id, url_id)
    SELECT tu.text_id, tu.url_id
    from edsssdb.text_url tu;

    INSERT INTO modified_edsssdb.url(url_id, url)
    SELECT u.url_id, u.url
    from edsssdb.url u;


