from langchain_openai import ChatOpenAI, OpenAIEmbeddings

from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.text_splitter import CharacterTextSplitter
from langchain import OpenAI
from langchain.document_loaders import DirectoryLoader
from langchain.chains import RetrievalQA

llm = ChatOpenAI(
            model='deepseek-chat',
            openai_api_key='',
            openai_api_base='https://api.deepseek.com/v1',
            temperature=0.85,
            max_tokens=4000
)

# 初始化 openai 的 embeddings 对象
embeddings = OpenAIEmbeddings(model="text-embedding-ada-002",
            openai_api_key='')

# 将 document 通过 openai 的 embeddings 对象计算 embedding 向量信息并临时存入 Chroma 向量数据库，用于后续匹配查询

vectorstore_directory = 'database'
docsearch = Chroma(
    embedding_function=embeddings,
    persist_directory=vectorstore_directory,
)

# 创建问答对象
qa = RetrievalQA.from_chain_type(llm=llm, chain_type="stuff", retriever=docsearch.as_retriever(), return_source_documents=True)

# 进行问答
result = qa({"query": "如何制作鞍具？"})
print(result)